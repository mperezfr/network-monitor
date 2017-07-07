#!/bin/bash

hostfreq=$1 # file with data

DATEPATTERN="Date_in_seconds:"

#Test the number of parameters
if (( $# < 1 )); then
  echo usage: $0 file
  exit
fi


inputfile=$hostfreq
outputfile=$hostfreq.out
columnas=3

#Test if the file exists
if [[ ! -f $inputfile ]]; then
  echo $inputfile does not exists
  exit
fi



# grep -a to tret the files as text, to avoid treat as a binary if there are NUL (\000) values in the file
for f in $DATEPATTERN; do  
   grep -a $f $inputfile |  awk '{print $2}' > $outputfile.$f.txt; 
done
for f in CCQ Signal; do  
   grep -a $f $inputfile |  awk '{print $5}' > $outputfile.$f.txt; 
done

f=$DATEPATTERN
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

for f in $DATEPATTERN CCQ Signal; do  
  rm $outputfile.$f.txt
done 
