#!/usr/bin/env bash

# Check which packages were brewed with options, and what the option flags were.

brew info --json=v1 --installed \
  | jq 'map({name: .name, version: .installed[].version, used_options: .installed[].used_options})' \
  | jq 'map(select(.used_options | length > 0))' \
  | jq 'group_by(.name)' \
  | jq 'map({key: .[0].name, value: . | map({version: .version, used_options: .used_options})})' \
  | jq 'from_entries'
