#! /bin/bash

i=0
while read line
do
    array[ $i ]="$line"        
    (( i++ ))
done < <(ls *.png)

### echo ${array[0]}

rm -f output.dat
COUNTER_OUTSIDE=0
while [  $COUNTER_OUTSIDE -lt $i ]; do
   COUNTER=0
   TEST_IMAGE=${array[$COUNTER_OUTSIDE]}
   SUM=0
   while [  $COUNTER -lt $i ]; do
      RESULT=`compare -metric phash $TEST_IMAGE ${array[$COUNTER]} null: 2>&1`
      SUM=`bc -l <<END
         scale=3
         $SUM + $RESULT
END`
      let COUNTER=COUNTER+1 
   done
   echo "${SUM} $TEST_IMAGE" 
   echo "${SUM} $TEST_IMAGE" >> output.dat
   let COUNTER_OUTSIDE=COUNTER_OUTSIDE+1 
done

sort -k1,1n output.dat
