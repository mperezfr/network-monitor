#!/bin/bash

host=$1
freq=$2


#Test the number of parameters
if (( $# < 2 )); then
  echo usage: $0 host freq
  exit
fi


inputfile=$host.$freq.in
outputfile=$host.$freq.out
columnas=3

#Test if the file exists
if [[ ! -f $inputfile ]]; then
  echo $inputfile does not exists
  exit
fi



# grep -a to tret the files as text, to avoid treat as a binary if there are NUL (\000) values in the file
for f in 1499; do  
   grep -a $f $inputfile  > $outputfile.$f.txt; 
done
for f in CCQ Signal; do  
   grep -a $f $inputfile |  awk '{print $5}' > $outputfile.$f.txt; 
done

f=1499
cp $outputfile.$f.txt $outputfile.last.txt
RAFI=$RANDOM.txt

#tail $outputfile.last.txt | less

for f in CCQ Signal; do  
  paste $outputfile.last.txt $outputfile.$f.txt > $RAFI
  mv $RAFI $outputfile.last.txt
  #tail $outputfile.last.txt | less
done

awk 'NF>='$columnas $outputfile.last.txt >  $RAFI
mv $RAFI $outputfile.last.txt

for f in 1499 CCQ Signal; do  
  rm $outputfile.$f.txt
done 
