BEGIN {
  timestamp = ""
  histentry = ""
  timestamp_regex = "^#[[:digit:]]{10}$"
  exclusion_regex = "^(ls?|man|cat)$"
}
{
  if (timestamp == "") {
    if ($0 ~ timestamp_regex) {
      timestamp = $0
    } else {
      print
    }
  } else if (histentry == "") {
    if ($0 ~ timestamp_regex && $0 >= timestamp) {
      timestamp = $0
    } else if ($1 ~ exclusion_regex) {
      histentry = $0
    } else {
      print timestamp
      print
      timestamp = ""
    }
  } else {
    if ($0 ~ timestamp_regex) {
      histentry = ""
      timestamp = $0
    } else {
      print timestamp
      print histentry
      print
      timestamp = ""
      histentry = ""
    }
  }
}
