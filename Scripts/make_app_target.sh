#!/bin/bash

out="."

while (( "$#" )); do
  case "$1" in
  	-name|--flag-with-argument)
      app_name=$2
      shift 2
      ;;
    -type|--flag-with-argument)
      app_type=$2
      shift 2
      ;;  
    -out|--flag-with-argument)
      out=$2
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

pushd $out > /dev/null

echo "$app_name~$app_type" >> PROJECTS

popd > /dev/null
