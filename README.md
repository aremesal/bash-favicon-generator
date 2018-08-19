# bash-favicon-generator

This is a very small and simple script to generate all the favicons for a website - and mobile - as well as the sidecar files.

## Usage

After cloning or download, be sure you have execution permissions:

`chmod +x favicon.sh`

To generate the favicon just call the script passing the original image file:

`./favicon.sh /path/to/image.png

If you want to set a title (for Android), pass a second argument:

`./favicon.sh /path/to/image.png "Title of my website"`

The script will create a folder 'favicon', and put inside all the files. Once finished, the script will show the HTML code to copy and paste in the website. Just do it, and copy all the contents of the favicon/* folder to the root of your website.

Please, remember that the image should be at least 553px
