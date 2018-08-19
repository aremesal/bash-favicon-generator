#!/usr/bin/env bash

# TODO:
# - Add website title
# - Option only 16x16
# - Reduce number of icons: https://realfavicongenerator.net/blog/new-favicon-package-less-is-more/

MIN_SIZE=558
BGCOLOR='transparent'
TITLE='Website'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

error_param() {
    echo -e "${RED}Error${NC}: you should pass an image as param"
}

help() {
	echo -e "Ayuda"
}

success_msg() {
    echo -e "\n${GREEN}All the favicons generated${NC}.\n\nYou can copy the contents of the './favicon' folder to the root of your website, and copy&paste the required HTML:"
    echo -e $HTML
    echo -e
}

imagick_present() {
    # command -v is POSIX compatible
    if ! command -v convert >/dev/null 2>&1 \
    || ! command -v identify >/dev/null 2>&1; then 
        echo "${RED}Error${NC}: you need ImageMagick. You can install with 'apt-get install imagemagick'"
        exit 1
    fi
}

valid_image() {

    # It's an image file
    if ! [ -f $1 ]; then
        echo "${RED}Error${NC}: file '$1' doesn't exist"
        help
        exit 1
    fi

    if ! file $1 |grep -qE 'image|bitmap' \
    || ! identify $1 >/dev/null 2>&1; then
        echo "${RED}Error: '$1' is a not an image file"
        exit 1
    fi

    # Size enough

    W=`identify -format '%w' $1`
    H=`identify -format '%h' $1`

    if [ $W -lt $MIN_SIZE ] \
    || [ $H -lt $MIN_SIZE ]; then
        echo "${RED}Error${NC}: '$1' is smaller than the minimum size ($MIN_SIZE x $MIN_SIZE)"
        exit 1
    fi
    
}

process_image() {
    # Check enviroment
    imagick_present

    # Check if it's a proper image
    valid_image $1

    # Dir for not mess with the files in pwd
    mkdir favicon
    if ! [ $? -eq 0 ]; then
        exit 1
    fi

    # Make the different sizes
    # Credits to: https://github.com/audreyr/favicon-cheat-sheet
    FNAME=$(basename -- "$1")
    EXT="${filename##*.}"

    # IMagick by default keep the aspect ratio, so
    #  parameters -background, -gravity center and -extent are used to center the image if the source is not square

    # Favicon .ico (16x16, 24x24, 32x32, 48x48, 64x64) and .png (16x16)
    convert $1 -define icon:auto-resize="64,48,32,24,16" favicon/favicon.ico    
    convert -resize 16x16 -background $BGCOLOR -gravity center -extent 16x16 $1 favicon/favicon.png

    # Old Chrome
    convert -resize 32x32 -background $BGCOLOR -gravity center -extent 32x32  $1 favicon/favicon-32.png

    # Android 36x36
    convert -resize 36x36  $1 favicon/android-icon-36x36.png

    # Android 48x48
    convert -resize 48x48 -background $BGCOLOR -gravity center -extent 48x48  $1 favicon/android-icon-48x48.png

    # Standard iOS home screen (iPod Touch, iPhone first generation to 3G)
    convert -resize 57x57 -background $BGCOLOR -gravity center -extent 57x57  $1 favicon/favicon-57.png

    # Apple 60x60
    convert -resize 60x60 -background $BGCOLOR -gravity center -extent 60x60  $1 favicon/favicon-60.png

    # IE 11 Tile for Windows 8.1 Start Screen
    convert -resize 70x70 -background $BGCOLOR -gravity center -extent 70x70  $1 favicon/ms-icon-70x70.png

    # Android 72x72
    convert -resize 72x72 -background $BGCOLOR -gravity center -extent 72x72  $1 favicon/android-icon-72x72.png

    # iPad home screen icon
    convert -resize 76x76 -background $BGCOLOR -gravity center -extent 76x76  $1 favicon/favicon-76.png
    
    # GoogleTV icon
    convert -resize 96x96 -background $BGCOLOR -gravity center -extent 96x96  $1 favicon/favicon-96.png

    # Android 96x96
    convert -resize 96x96 -background $BGCOLOR -gravity center -extent 96x96  $1 favicon/android-icon-96x96.png

    # Apple 114x114
    convert -resize 114x114 -background $BGCOLOR -gravity center -extent 114x114  $1 favicon/favicon-114.png

    # iPhone retina touch icon (Change for iOS 7: up from 114x114)
    convert -resize 120x120 -background $BGCOLOR -gravity center -extent 120x120  $1 favicon/favicon-120.png

    # Chrome Web Store icon
    convert -resize 128x128 -background $BGCOLOR -gravity center -extent 128x128  $1 favicon/favicon-128.png

    # Small Windows 8 Star Screen Icon
    cp favicon/favicon-128.png favicon/smalltile.png

    # IE10 Metro tile for pinned site    
    convert -resize 144x144 -background $BGCOLOR -gravity center -extent 144x144  $1 favicon/favicon-144.png

    # Android 144x144
    convert -resize 144x144 -background $BGCOLOR -gravity center -extent 144x144  $1 favicon/android-icon-144x144.png

    # iPad retina touch icon (Change for iOS 7: up from 144x144)
    convert -resize 152x152 -background $BGCOLOR -gravity center -extent 152x152  $1 favicon/favicon-152.png

    # iPhone 6 plus
    convert -resize 180x180 -background $BGCOLOR -gravity center -extent 180x180  $1 favicon/favicon-180.png

    # Android 192x192
    convert -resize 192x192 -background $BGCOLOR -gravity center -extent 192x192  $1 favicon/android-icon-192x192.png

    # Opera Speed Dial icon (Not working in Opera 15 and later) 
    convert -resize 195x195 -background $BGCOLOR -gravity center -extent 195x195  $1 favicon/favicon-195.png

    # Chrome for Android home screen icon
    convert -resize 196x196 -background $BGCOLOR -gravity center -extent 196x196  $1 favicon/favicon-196.png

    # Opera Coast icon 
    convert -resize 228x228 -background $BGCOLOR -gravity center -extent 228x228  $1 favicon/favicon-228.png

    # Medium Windows 8 Start Screen Icon
    convert -resize 270x270 -background $BGCOLOR -gravity center -extent 270x270  $1 favicon/mediumtile.png

    # Wide Windows 8 Start Screen Icon
    convert -resize 558x270 -background $BGCOLOR $1 favicon/widetile.png

    # Large Windows 8 Start Screen Icon
    convert -resize 558x558 -background $BGCOLOR -gravity center -extent 558x558  $1 favicon/largetile.png

    # IE 11 Tile for Windows 8.1 Start Screen
    cat >favicon/ieconfig.xml <<EOF
<?xml version="1.0" encoding="utf-8"?>
    <browserconfig>
      <msapplication>
        <tile>
          <square70x70logo src="/ms-icon-70x70.png"/>
          <square128x128logo src="/smalltile.png"/>
          <square150x150logo src="/mediumtile.png"/>
          <wide310x150logo src="/widetile.png"/>
          <square310x310logo src="/largetile.png"/>
          <TileColor>#FFFFFF</TileColor>
        </tile>
      </msapplication>
    </browserconfig>
EOF


    # manifest.json for Android
    cat >favicon/manifest.json <<EOF
{
 "name": "$TITLE",
 "icons": [
  {
   "src": "\/android-icon-36x36.png",
   "sizes": "36x36",
   "type": "image\/png",
   "density": "0.75"
  },
  {
   "src": "\/android-icon-48x48.png",
   "sizes": "48x48",
   "type": "image\/png",
   "density": "1.0"
  },
  {
   "src": "\/android-icon-72x72.png",
   "sizes": "72x72",
   "type": "image\/png",
   "density": "1.5"
  },
  {
   "src": "\/android-icon-96x96.png",
   "sizes": "96x96",
   "type": "image\/png",
   "density": "2.0"
  },
  {
   "src": "\/android-icon-144x144.png",
   "sizes": "144x144",
   "type": "image\/png",
   "density": "3.0"
  },
  {
   "src": "\/android-icon-192x192.png",
   "sizes": "192x192",
   "type": "image\/png",
   "density": "4.0"
  }
 ]
}
EOF

    # HTML for copy&paste
    read -r -d '' HTML << EOF
\n
<link rel="apple-touch-icon" sizes="57x57" href="/favicon-57.png">\n
<link rel="apple-touch-icon" sizes="60x60" href="/favicon-60.png">\n
<link rel="apple-touch-icon" sizes="72x72" href="/android-icon-72x72.png">\n
<link rel="apple-touch-icon" sizes="76x76" href="/favicon-76.png">\n
<link rel="apple-touch-icon" sizes="114x114" href="/favicon-114.png">\n
<link rel="apple-touch-icon" sizes="120x120" href="/favicon-120.png">\n
<link rel="apple-touch-icon" sizes="144x144" href="/favicon-144.png">\n
<link rel="apple-touch-icon" sizes="152x152" href="/favicon-152.png">\n
<link rel="apple-touch-icon" sizes="180x180" href="/favicon-180.png">\n
<link rel="icon" type="image/png" sizes="192x192"  href="/android-icon-192x192.png">\n
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32.png">\n
<link rel="icon" type="image/png" sizes="96x96" href="/favicon-96.png">\n
<link rel="icon" type="image/png" sizes="16x16" href="/favicon.png">\n
<link rel="manifest" href="/manifest.json">\n
<meta name="msapplication-TileColor" content="#ffffff">\n
<meta name="msapplication-TileImage" content="/favicon-144.png">\n
<meta name="theme-color" content="#ffffff">\n
EOF

    success_msg
}

# BEGIN ACTION

if [[ $# -eq 0 ]] ; then
    error_param
    help
    exit 0
fi

if [[ $# -eq 2 ]] ; then
    TITLE=$2
fi

case "$1" in
    h) help ;;
    *) process_image $1 ;;
esac

exit 0

# Si no hay ninguno o es -h mostrar ayuda
