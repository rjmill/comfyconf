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

  # TODO: Write a more helpful error message. Also find a more elegant way for
  # error handling here
  [[ -e "$origin" ]] || exit 1

  if [[ $# -eq 2 ]]; then
    ln --symbolic -- "$origin" "$destination" || exit 1
    exit 0
  elif [[ $# -ne 3 ]]; then
    # FIXME: heredoc this
    echo "Invalid number of arguments. Accepts two arguments and an optional callback" >&2
  fi

  if [[ -e "$destination" ]]; then
    # TODO: Write this to call ln -s on success and print error on fail.
    $3 "$destination" "$origin"
  fi
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
