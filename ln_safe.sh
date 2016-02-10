#!/bin/bash
## NOTE: UNTESTED
# Create a symlink from $origin to $destination. Accepts a callback for handling
# conflicts. If there is already a file at $destination and a callback has been
# passed in, pass in $destination $origin to the callback.
#
# ln_safe $origin $destination [$optional_callback]
#
# NOTE: This can probably be used to rewrite mvlns too
ln_safe() {
  local origin=$1
  local destination=$2
  local callback=$3

  [[ -e "$origin" ]] || exit 1

  if [[ $# -ne 3 ]]; then
    # FIXME: heredoc this
    echo "Invalid number of arguments. Accepts two arguments and an optional callback" >&2
    exit 1
  fi

  "$callback" "$destination" "$origin"
}

# This is the kind of code that would go in a callback, probably?
: <<'END'
if [[ -a $1 ]]; then
  mv --no-clobber -- "$1" "$1.old" || exit 1
  echo "Moved $1 to $1.old"
fi

ln --symbolic -- "~/.dotfiles/$1" "$1"

echo "Symlink from"~/.dotfiles/$1 to $1 created"

echo "Differences:"
diff -- "$1.old" "$1"
END
