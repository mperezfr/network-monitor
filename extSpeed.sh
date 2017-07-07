#!/bin/bash

hostfreq=$1 # file with data

DATEPATTERN=1499
DATEPATTERN=CEST

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
   grep -a $f $inputfile  > $outputfile.$f.txt
done

#convert FIXME QUITAR
# This is if the date has bee stored using date (not date +%s)
date --date="jul  7 08:47:08 CEST 2017" +%s
while read line; do  l=${line:4}; date --date="$l" +%s; done < $outputfile.$f.txt > KKKK
mv KKKK $outputfile.$f.txt

for f in Download; do  
   #grep -a $f $inputfile |  awk '{print $5}' > $outputfile.$f.txt; 
   cat $inputfile | sed -z 's/\n'$f'/ '$f'/g' | sed -z 's/KB\/s/ KB\/s/g' | grep $f |  awk '{print $7*8}' > $outputfile.$f.txt
done
for f in Upload; do  
   #grep -a $f $inputfile |  awk '{print $5}' > $outputfile.$f.txt; 
   cat $inputfile | sed -z 's/\n'$f'/ '$f'/g' | sed -z 's/ s,/s,/g' | grep $f |  awk '{print $7}' | sed -z 's/,/./g' | awk '{print $1*8}' > $outputfile.$f.txt
done

f=$DATEPATTERN
cp $outputfile.$f.txt $outputfile.last.txt
RAFI=$RANDOM.txt

# tail $outputfile.last.txt | less

for f in Download Upload; do  
  paste $outputfile.last.txt $outputfile.$f.txt > $RAFI
  mv $RAFI $outputfile.last.txt
  #tail $outputfile.last.txt | less
done

#Delete files with less than n columns
awk 'NF>='$columnas $outputfile.last.txt >  $RAFI
mv $RAFI $outputfile.last.txt



for f in $DATEPATTERN Download Upload; do  
  rm $outputfile.$f.txt
done 
