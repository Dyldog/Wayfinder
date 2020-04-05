#!/bin/bash

PARAMS=""

rundir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
realpath="$rundir/realpath.py"

out="."

while (( "$#" )); do
  case "$1" in
  	-name|--flag-with-argument)
      name=$2
      shift 2
      ;;
    -color|--flag-with-argument)
      color=$2
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

mkdir -p $name.imageset
pushd $name.imageset > /dev/null

cat > Contents.json << EOF      
{
  "images" : [
    {
      "idiom" : "universal",
      "filename" : "$name.png"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
EOF

convert -size 1x1 xc:#$color $name.png

# Back to Images.xcassets
popd > /dev/null

mv $name.imageset $out