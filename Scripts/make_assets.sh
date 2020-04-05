#!/bin/bash

rundir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
realpath="$rundir/realpath.py"
make_stretchable_image="$rundir/make_stretchable_image.sh"

PARAMS=""

out="."

while (( "$#" )); do
  case "$1" in
  	-name|--flag-with-argument)
      app_name="$2Finder"
      shift 2
      ;;
    -in|--flag-with-argument)
      in_file=$(python $realpath $2)
      shift 2
      ;;
    -out|--flag-with-argument)
      out=$2
      shift 2
      ;;
    -toolbar|--flag-with-argument)
      toolbar=$2
      shift 2
      ;;
    -background|--flag-with-argument)
      background=$2
      shift 2
      ;;
    -h1|--flag-with-argument)
      h1=$2
      shift 2
      ;;
    -h2|--flag-with-argument)
      h2=$2
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

echo "Name: "$app_name
echo "File: "$in_file

pushd "$out" > /dev/null

## ---------------------- ##
## -------- ICON -------- ##
## ---------------------- ##

mkdir -p /tmp/icon_assets/
mkdir -p $app_name

convert $in_file -gravity center -resize 860x860 -background "#$background" -extent 1024x1024 /tmp/icon_assets/background_out.png

pushd "$app_name" > /dev/null

mkdir -p "Resources"
pushd "Resources" > /dev/null

xcassets --icon /tmp/icon_assets/background_out.png > /dev/null

pushd Images.xcassets > /dev/null

## ---------------------- ##
## -------- ARROW ------- ##
## ---------------------- ##

mkdir -p Arrow.imageset

cat > Arrow.imageset/Contents.json << EOF      
{
  "images" : [
    {
      "idiom" : "universal",
      "filename" : "Arrow.png"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
EOF

cp "$in_file" Arrow.imageset/Arrow.png

## ----------------------------- ##
## -------- LAUNCH IMAGE ------- ##
## ----------------------------- ##


$make_stretchable_image -name LaunchBG -color $background

## ----------------------------- ##
## -------- LAUNCH TOOLBAR ------- ##
## ----------------------------- ##

$make_stretchable_image -name LaunchToolbarBG -color $toolbar

# Back to Resources
popd > /dev/null

# Back to app dir
popd > /dev/null

## ------------------------ ##
## -------- COLOURS ------- ##
## ------------------------ ##

mkdir -p Sources

cat > Sources/Colors.swift << EOF      
import UIKit

extension UIColor {
    static let toolbar = UIColor(hex: "$toolbar")
    static let h1 = UIColor(hex: "$h1")
    static let h2 = UIColor(hex: "$h2")
    static let background = UIColor(hex: "$background")
}
EOF

# Back to out
popd > /dev/null
