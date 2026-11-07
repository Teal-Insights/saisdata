#!/bin/bash
# The student's one line on a Mac, in empty libraries and fresh R sessions.
#
#   data-raw/verification/run-mac.sh <expected-commit> <expected-version>
#
# Every R session starts from an empty environment with an empty home folder, so
# nothing from this machine's profile, tokens or library settings reaches it. Fake
# compilers sit first on the PATH and write down any call. A logging proxy writes
# down every host contacted during the install. The use step runs with the network
# denied by sandbox-exec. Exits 1 if any check fails.
set -u

expect_sha=$1
expect_version=$2
here=$(cd "$(dirname "$0")" && pwd)
line='install.packages("saisdata", repos = "https://teal-insights.r-universe.dev")'

work=$(mktemp -d)
mkdir -p "$work/home" "$work/tmp" "$work/trap" "$work/lib-rscript" "$work/lib-interactive" "$work/cwd"
for tool in clang clang++ gcc g++ cc c++ make gfortran; do
  printf '#!/bin/sh\necho "$0 $*" >> "%s/compiler-calls.log"\nexit 1\n' "$work" > "$work/trap/$tool"
  chmod +x "$work/trap/$tool"
done
: > "$work/compiler-calls.log"
: > "$work/hosts.log"

python3 -I "$here/log-hosts-proxy.py" "$work/hosts.log" "$work/port" &
proxy=$!
trap 'kill "$proxy" 2>/dev/null' EXIT
for _ in 1 2 3 4 5 6 7 8 9 10; do
  [ -s "$work/port" ] && break
  /bin/sleep 0.5
done
port=$(cat "$work/port")

failed=0
result() { # result <exit code> <what>
  if [ "$1" -eq 0 ]; then echo "PASS  $2"; else echo "FAIL  $2"; failed=1; fi
}

clean=(
  env -i
  "HOME=$work/home" "TMPDIR=$work/tmp" "LANG=en_US.UTF-8"
  "PATH=$work/trap:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
)
through_proxy=("https_proxy=http://127.0.0.1:$port" "http_proxy=http://127.0.0.1:$port")
expect=("SAISDATA_EXPECT_SHA=$expect_sha" "SAISDATA_EXPECT_VERSION=$expect_version")
no_network='(version 1)(allow default)(deny network*)'

echo "== This machine"
sw_vers -productVersion
uname -m
"${clean[@]}" R --version | head -1
"${clean[@]}" Rscript --vanilla -e 'cat("pkgType option:", getOption("pkgType"), "\nbinary type:", .Platform$pkgType, "\n")'
echo "tokens in the session environment: none, it starts from env -i"
echo

cd "$work/cwd" || exit 1

echo "== 1. The exact line, non-interactive, in an empty library"
echo "$line"
"${clean[@]}" "${through_proxy[@]}" "R_LIBS_USER=$work/lib-rscript" \
  Rscript --vanilla "$here/../verify-student-install.R" install 2>&1
result $? "Rscript install exits 0"
echo

echo "== 2. The exact line, in an interactive session, in a second empty library"
printf '%s\n%s\n%s\n' 'cat("interactive session:", interactive(), "\n")' "$line" 'q("no")' > "$work/line.R"
"${clean[@]}" "${through_proxy[@]}" "R_LIBS_USER=$work/lib-interactive" \
  R --interactive --vanilla --no-echo < "$work/line.R" > "$work/interactive.log" 2>&1
code=$?
cat "$work/interactive.log"
result "$code" "the interactive session exits 0"
grep -q 'interactive session: TRUE' "$work/interactive.log"
result $? "the session really was interactive, so the prompt check means something"
ls "$work/lib-interactive" | grep -qx saisdata
result $? "saisdata is installed in the second library"
! grep -E 'Would you like|Yes/no/cancel|Selection:|Do you want' "$work/interactive.log"
result $? "it did not stop to prompt"
! grep -iE '^warning|warning message' "$work/interactive.log"
result $? "it gave no warning"
echo

echo "== 3. What the install needed"
echo "hosts contacted during both installs:"
sort -u "$work/hosts.log" | sed 's/^/  /'
grep -qx 'teal-insights.r-universe.dev' "$work/hosts.log"
result $? "the proxy saw the R-universe host, so R did use it"
# R-universe answers a download with a redirect to its file store, r2.ropensci.org.
! grep -vxE 'teal-insights\.r-universe\.dev|r2\.ropensci\.org' "$work/hosts.log"
result $? "only R-universe and its file store were contacted, so no CRAN and no GitHub"
if [ -s "$work/compiler-calls.log" ]; then cat "$work/compiler-calls.log"; fi
[ ! -s "$work/compiler-calls.log" ]
result $? "no compiler or make was called"
echo

echo "== 4. Network denied: the control"
"${clean[@]}" /usr/bin/sandbox-exec -p "$no_network" \
  /usr/bin/curl -s -m 10 -o /dev/null https://teal-insights.r-universe.dev/
code=$?
echo "curl to R-universe inside the sandbox exited $code"
[ "$code" -ne 0 ]
result $? "the sandbox does block the network"
echo

echo "== 5. A fresh session, network denied: load, help pages, example"
"${clean[@]}" "${expect[@]}" "R_LIBS_USER=$work/lib-rscript" \
  /usr/bin/sandbox-exec -p "$no_network" \
  Rscript --vanilla "$here/../verify-student-install.R" use 2>&1
result $? "the use step exits 0 with the network denied"
echo

echo "== 6. The same in the library the interactive install made"
"${clean[@]}" "${expect[@]}" "R_LIBS_USER=$work/lib-interactive" \
  /usr/bin/sandbox-exec -p "$no_network" \
  Rscript --vanilla "$here/../verify-student-install.R" use > "$work/use2.log" 2>&1
code=$?
grep -E '^(Version|RemoteSha|RemoteRef|Repository):|^All checks passed|^FAIL' "$work/use2.log"
result "$code" "the use step exits 0 for the interactive library too"
echo

echo "== 7. What a student types, in an interactive session, network denied"
cat > "$work/student.R" <<'STUDENT'
library(saisdata)
?weo
?weo_groups
?wb_groups
head(as.data.frame(weo), 3)
kenya <- subset(weo, code == "KEN" & year >= 2020 & year <= 2025)
kenya$net_interest <- kenya$primary_balance - kenya$overall_balance
as.data.frame(kenya[, c("year", "gross_debt", "net_interest")])
file.exists(system.file("doc", "saisdata.html", package = "saisdata"))
q("no")
STUDENT
"${clean[@]}" "R_LIBS_USER=$work/lib-interactive" \
  /usr/bin/sandbox-exec -p "$no_network" \
  R --interactive --vanilla < "$work/student.R" > "$work/student.log" 2>&1
code=$?
/usr/bin/col -bx < "$work/student.log"
result "$code" "the student session exits 0"
! grep -E '^Error' "$work/student.log"
result $? "the student session printed no error"
echo

if [ "$failed" -eq 0 ]; then echo "Result: ALL PASSED"; else echo "Result: FAILED"; fi
exit "$failed"
