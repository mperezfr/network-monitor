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



# grep -a to treat the files as text, to avoid treat as a binary if there are NUL (\000) values in the file
for f in "$DATEPATTERN"; do  
   grep -a $f $inputfile |  awk '{print $2}'  > $outputfile.$f.txt
done


for f in Download; do  
   cat $inputfile | sed -z 's/\n'$f'/ '$f'/g' | grep $f |  awk '{print $1}' > $outputfile.$f.txt
done
for g in Upload; do  
   cat $inputfile | sed -z 's/\n'$f'/ '$f'/g' | grep $f |  awk '{print $1}' > $outputfile.$g.txt
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
#awk 'NF>='$columnas $outputfile.last.txt >  $RAFI
#mv $RAFI $outputfile.last.txt



for f in "$DATEPATTERN" Download Upload; do  
  rm $outputfile.$f.txt
done 
