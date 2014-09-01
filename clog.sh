#!/bin/bash
#
# Find all the rails projects from this directory down
# and report the size of their log directory.

paths=$(find $(pwd) -type f -path '*/config/environment.rb')
for path in $paths; do
  rails_root=$(echo "$path" | xargs dirname | xargs dirname)
  echo "Found RAILS_ROOT in $rails_root"
  pushd "$rails_root" >/dev/null

  du -h log
  # if bundle exec rake log:clear; then
  #   echo "cleared log for $(pwd)"
  # else
  #   echo "failed to clear log for $(pwd)"
  # fi

  popd >/dev/null
  echo
done
