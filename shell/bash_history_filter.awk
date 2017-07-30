BEGIN {
  timestamp = ""
  entryline = ""
  timestamp_regex = "^#[[:digit:]]{10}$"
  exclusion_regex = "^(ls?|man|cat)$"
  state = "begin"
}
{
  if (state == "begin")
  {
    if ($0 ~ timestamp_regex)
    {
      timestamp = $0
      state = "readtimestamp"
    }
    else
    {
      print
      state = "printedline"
    }
  }
  else if (state == "printedline")
  {
    if ($0 ~ timestamp_regex)
    {
      timestamp = $0
      state = "readtimestamp"
    }
    else
    {
      print
      state = "printedline"
    }
  }
  else if (state == "readtimestamp")
  {
    if ($0 ~ timestamp_regex && $0 >= timestamp)
    {
      timestamp = $0
      state = "readtimestamp"
    }
    else if ($1 ~ exclusion_regex)
    {
      entryline = $0
      state = "readentryline"
    }
    else
    {
      print timestamp
      print
      state = "printedline"
    }
  }
  else if (state == "readentryline")
  {
    if ($0 ~ timestamp_regex)
    {
      entryline = ""
      timestamp = $0
      state = "readtimestamp"
    }
    else
    {
      print timestamp
      print entryline
      print
      state = "printedline"
    }
  }
}
