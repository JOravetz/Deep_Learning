#! /bin/bash

i=0
while read line
do
    array[ $i ]="$line"        
    (( i++ ))
done < <(ls *.png)

### echo ${array[0]}

COUNTER_OUTSIDE=0
while [  $COUNTER_OUTSIDE -lt $i ]; do
   COUNTER=0
   TEST_IMAGE=${array[$COUNTER_OUTSIDE]}
   rm -f output.dat
   while [  $COUNTER -lt $i ]; do
      RESULT=`compare -metric phash $TEST_IMAGE ${array[$COUNTER]} null: 2>&1`
      echo "${RESULT} $TEST_IMAGE ${array[$COUNTER]}" >> output.dat
      let COUNTER=COUNTER+1 
   done
   DIFFERENT=`sort -k1,1n output.dat | tail -1`
   echo "${COUNTER_OUTSIDE} Test Image = $TEST_IMAGE Most Different = ${DIFFERENT}"
   let COUNTER_OUTSIDE=COUNTER_OUTSIDE+1 
done
