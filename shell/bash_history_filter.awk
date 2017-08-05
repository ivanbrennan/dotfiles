/^#[[:digit:]]{10}$/ {
  timestamp = $0
  histentry = ""
  next
}
($1 ~ /^(ls?|man|cat)$/) || /^[[:alpha:]]$/ {
  if (! timestamp) {
    print
  } else {
    histentry = $0
  }
  next
}
timestamp {
  print timestamp
  timestamp = ""
}
histentry {
  print histentry
  histentry = ""
}
{ print }
