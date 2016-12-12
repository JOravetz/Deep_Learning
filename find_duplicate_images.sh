#! /bin/bash

### Check program options.
while [ X"$1" != X-- ]
do
    case "$1" in
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
   ls -l | grep '^d' | awk '{print $9}' > sub_directories.lis
   SUM=0
   while read SUB_DIRECTORY; do
      cd ./${SUB_DIRECTORY}
      echo "Primary Directory = ${DIRECTORY}, Sub-Directory = ${SUB_DIRECTORY}"
      unique_images=`md5sum *.png | sort -k1,1n | awk '{print $2, $1}' | uniq -f 1 | wc -l | awk '{print $1}'`
      total_images=`ls -alt *.png | wc -l | awk '{print $1}'`
      duplicates=`bc -l <<END
         ${total_images} - ${unique_images}
END`
      echo "   Total images = ${total_images}, Unique images = ${unique_images}, Duplicates = ${duplicates}"
      SUM=`expr ${SUM} + ${duplicates}`
      cd ..
   done < sub_directories.lis
   echo "   ---> Total number of Duplicate files in sub-directories = ${SUM}"
   rm -f sub_directories.lis
   cd ..

   ### Remove duplicate files ###
   fdupes -r . -d -N
   fdupes -r . -m

done < directories.lis
rm -f directories.lis
