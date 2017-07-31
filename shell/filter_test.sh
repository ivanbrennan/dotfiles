#!/usr/bin/env bash

infile=$(mktemp)
outfile=$(mktemp)
comparefile=$(mktemp)
diffout=$(mktemp)
trap 'rm -f "$infile" "$outfile" "$comparefile" "$diffout"' EXIT

awkscript=$1
histfile=$2
grandcomparefile=$3
[[ -r "$awkscript"   ]] || { echo "Error: can't read $awkscript";   exit 1; }
[[ -r "$histfile"    ]] || { echo "Error: can't read $histfile";    exit 1; }
[[ -r "$grandcomparefile" ]] || { echo "Error: can't read $grandcomparefile"; exit 1; }

col_red="\033[31;01m"
col_green="\033[32;01m"
col_reset="\033[39;49;00m"


main() {
  printf 'Test - empty history file...'
  > "$infile"
  > "$comparefile"
  run_test

  printf 'Test - one-line entry...'
  printf 'abc\n' > "$infile"
  printf 'abc\n' > "$comparefile"
  run_test

  printf 'Test - multiple one-line entries...'
  cat <<EOF > "$infile"
abc
def
EOF
  cat <<EOF > "$comparefile"
abc
def
EOF
  run_test

  printf 'Test - almost timestamp...'
  printf '#012345678\n' > "$infile"
  printf '#012345678\n' > "$comparefile"
  run_test

  printf 'Test - compare against known results...'
  cp "$histfile" "$infile"
  cp "$grandcomparefile" "$comparefile"
  run_test
}

run_test() {
  awk -f "$awkscript" "$infile"  >"$outfile"
  compare_results
}

compare_results() {
  if diff "$comparefile" "$outfile" >"$diffout"; then
    report_success
  else
    report_failure
  fi
}

report_success() {
  printf '%b✓%b\n' "$col_green" "$col_reset"
}

report_failure() {
  printf '%b✗%b\n' "$col_red" "$col_reset"
  echo "Diff:"
  cat "$diffout"
}

main
