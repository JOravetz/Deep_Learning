#! /bin/bash

NUM=100

### Check program options.
while [ X"$1" != X-- ]
do
    case "$1" in
       -n) NUM="$2"
           shift 2
           ;;
   -debug) echo "DEBUG ON"
           set -x
           DEBUG="yes"
           trap '' SIGHUP SIGINT SIGQUIT SIGTERM
           shift 1
           ;;
       -*) echo "${program}: Invalid parameter $1: ignored." 1>&2
           shift
           ;;
        *) set -- -- $@
           ;;
    esac
done
shift           # remove -- of arguments

ls -l | grep '^d' | awk '{print $9}' > directories.lis
while read DIRECTORY; do
   cd ./${DIRECTORY}
   mkdir temp
   ls | sort -R | tail -${NUM} | while read FILE; do
      cp ${FILE} temp   
   done
   montage -background '#000000' -fill 'gray' -geometry 28x28+4+4 ./temp/*.png montage.png
   ### display montage.png &
   cp montage.png ../${DIRECTORY}.montage.png
   rm -rf temp
   cd ..
done < directories.lis
montage -border 2 -label '%f' -font Helvetica -pointsize 10 -background '#000000' -fill 'gray' -geometry 240x240+4+4 ?.montage.png combined.montages.jpg
display combined.montages.jpg &
find . -name "montage.png" -exec rm -f {} \;
rm -f ?.montage.png directories.lis
sleep 10
killall display
