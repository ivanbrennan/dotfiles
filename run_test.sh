[ -p test_commands ] || mkfifo test_commands

while true; do
  $(< test_commands)
done
