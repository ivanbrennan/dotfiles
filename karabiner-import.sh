#!/bin/sh

# To export new settings, run:
# /Applications/Karabiner.app/Contents/Library/bin/karabiner export

cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

$cli be_careful_to_use__clear_all_values_by_name Default
/bin/echo -n .

# Reduce the delay applied in distiguishing modifier key-use from individual key-presses.
# https://github.com/tekezo/Karabiner/commit/366e4854ca807c4594b53351447f710ac456058b
$cli set parameter.blockuntilkeyup_timeout 2
/bin/echo -n .
# Reduce the timeout in registering Escape when using hybrid Control/Escape key.
# https://github.com/tekezo/Karabiner/issues/226
$cli set parameter.holdingkeytokey_wait 2
/bin/echo -n .
# Reduce the delay applied to modifier keys, but not enough to risk dropping events.
# https://github.com/tekezo/Karabiner/commit/8562887b05e0797ab506940dc6efd5026ed3cc34
$cli set parameter.wait_before_and_after_a_modifier_key_event 5
/bin/echo -n .

# This is most useful once you've changed Caps Lock to Control in System Preferences.
# Control when used as a modifier, Escape when used alone. Great for vim.
$cli set remap.controlL2controlL_escape 1
/bin/echo -n .

# Avoid accidental Command Q quits by requiring a double press
$cli set remap.doublepresscommandQ 1
/bin/echo -n .

# Control when used as a modifier, Return when used alone. Great for emacs.
$cli set remap.return2controlL_return_keyrepeat 1
/bin/echo -n .

# Dual Shift activates Caps Lock, single Shift deactivates it.
$cli set remap.shiftLshiftR_to_capslock 1
/bin/echo -n .
$cli set remap.shiftRshiftL_to_capslock 1
/bin/echo -n .

# Media key repeat settings
$cli set repeat.consumer_initial_wait 200
/bin/echo -n .
$cli set repeat.consumer_wait 30
/bin/echo -n .
# Regular key repeat settings
$cli set repeat.initial_wait 300
/bin/echo -n .
$cli set repeat.wait 30
/bin/echo -n .

/bin/echo
