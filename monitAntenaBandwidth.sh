#!/bin/bash

verbatim=1
DATEPATTERN="Date_in_seconds:"


host=$1
IF=$2
if [ -z "$IF" ]; then
        IF=`ls -1 /sys/class/net/ | head -1`
fi


while :; do
echo $DATEPATTERN `date +%s`


megas=2
  ssh ubnt@$host "rm zzz; touch zzz;echo ${IF} > zzz;
                  cat /sys/class/net/${IF}/statistics/tx_bytes>> zzz;
                  echo \`adjtimex | grep tv_sec | awk '{print \$2}'\`\`adjtimex | grep tv_usec | awk '{print \$2}'\` >> zzz;
                  dd if=/dev/zero bs=4096 count=$((1024*${megas}/4));
                  cat /sys/class/net/${IF}/statistics/tx_bytes>> zzz;
                  echo \`adjtimex | grep tv_sec | awk '{print \$2}'\`\`adjtimex | grep tv_usec | awk '{print \$2}'\` >> zzz;" | cat > /dev/null

  scp ubnt@$host:zzz .
  ssh ubnt@$host rm "zzz"
  

  TPR=`sed -n '2p' < zzz`
  TXPREV=`sed -n '3p' < zzz`
  TPT=`sed -n '4p' < zzz`
  TX=`sed -n '5p' < zzz`

  let BWTX=$TX-$TXPREV
  let MICSECS=$((TPT-TPR))

  # echo "Received: $BWRX B/s    Sent: $BWTX B/s"
  #echo $((TX-TXPREV))
  #echo $MICSECS
  echo $((BWTX*8*1000000/MICSECS))
  echo Download

  sleep 600 
done
