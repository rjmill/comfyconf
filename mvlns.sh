#!/bin/bash
##
# A simple bash script to move a file into a new directory and create a symbolic
# link from its original location to its new location
# TODO: Make this accept optional conflict callback
mvlns() {
  local file_origin="$1"
  local file_destination="$2"

  mv --no-clobber -- "$file_origin" "$file_destination" || exit 1
  if [[ -d $file_destination ]]; then
    file_destination=$(cd -- "$file_destination" && pwd)/"$file_origin"
    ln --symbolic -- "$file_destination" "$file_origin"
  elif [[ -f $file_destination ]]; then
    ln --symbolic -- "$file_destination" "$file_origin"
  fi

  echo "$file_origin moved to $file_destination, and symbolic link from $file_origin created"
}

mvlns $1 $2
