# shellcheck shell=bash

# ============
# Locale tests
# ============

function test_if_locale_available() {
  local query=$1
  locale -a | grep -q "$query" > /dev/null
  return $?
}

# while locale en_US.UTF-8 is specifically tailored for US English,
# it is not supported by default by minimal POSIX distributions,
# and under Debian, ignores leading underscores while sorting,
# which causes these profile files to be executed in the wrong order.
# The general recommendation is to use locale C.UTF-8 instead.

if test_if_locale_available "C.UTF-8"; then
  export LC_ALL=C.UTF-8
  export LANG=C.UTF-8
  export LANGUAGE=C.UTF-8
fi

# if we cannot set locale to C.UTF-8, we try to set it to en_US.UTF-8
if test_if_locale_available "en_US.UTF-8"; then
  export LC_ALL=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LANGUAGE=en_US.UTF-8
fi

# Note: darwin/macos does not support glibc style locales
# That said, you can try the following to test your current platform
# for C.UTF-8 support: nix-shell -p glibcLocales
