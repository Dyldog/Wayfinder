#!/bin/bash

rundir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
make_stretchable_image="$rundir/make_stretchable_image.sh"

PARAMS=""

out="."

while (( "$#" )); do
  case "$1" in
  	-background|--flag-with-argument)
      background=$2
      shift 2
      ;;
    -toolbar|--flag-with-argument)
      toolbar=$2
      shift 2
      ;;
    -out|--flag-with-argument)
      out=$(python $realpath $2)
      shift 2
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

$make_stretchable_image -name "LaunchBG" -color "$background" -out "$out"
$make_stretchable_image -name "LaunchToolbarBG" -color "$toolbar" -out "$out"