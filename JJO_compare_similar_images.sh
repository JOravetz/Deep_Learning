#! /bin/bash

i=0
while read line
do
    array[ $i ]="$line"        
    (( i++ ))
done < <(ls *.png)

### echo ${array[0]}

rm -f output.dat
COUNTER=1
while [  $COUNTER -lt $i ]; do
   let J=COUNTER-1 
   RESULT=`compare -metric phash ${array[$J]} ${array[$COUNTER]} null: 2>&1`
   echo "${RESULT} ${array[$J]} ${array[$COUNTER]}" 
   echo "${RESULT} ${array[$J]} ${array[$COUNTER]}" >> output.dat
   let COUNTER=COUNTER+1 
done

sort -k1,1n output.dat
