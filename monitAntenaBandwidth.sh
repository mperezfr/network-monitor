#!/bin/bash

verbatim=1
DATEPATTERN="Date_in_seconds:"


host=$1
IF=$2
LOGFILE=$1.log

if [ -z "$IF" ]; then
        IF=`ls -1 /sys/class/net/ | head -1`
fi


while :; do
echo $DATEPATTERN `date +%s`


megas=2
  ssh ubnt@$host "echo ${IF} > ${LOGFILE};
                  cat /sys/class/net/${IF}/statistics/tx_bytes>> ${LOGFILE};
                  echo \`adjtimex | grep tv_sec | awk '{print \$2}'\`\`adjtimex | grep tv_usec | awk '{print \$2}'\` >> ${LOGFILE};
                  dd if=/dev/zero bs=4096 count=$((1024*${megas}/4));
                  cat /sys/class/net/${IF}/statistics/tx_bytes>> ${LOGFILE};
                  echo \`adjtimex | grep tv_sec | awk '{print \$2}'\`\`adjtimex | grep tv_usec | awk '{print \$2}'\` >> ${LOGFILE};" | cat > /dev/null

  scp ubnt@$host:$LOGFILE .
  ssh ubnt@$host rm "${LOGFILE}"
  

  TPR=`sed -n '2p' < $LOGFILE`
  TXPREV=`sed -n '3p' < $LOGFILE`
  TPT=`sed -n '4p' < $LOGFILE`
  TX=`sed -n '5p' < $LOGFILE`

  let BWTX=$TX-$TXPREV
  let MICSECS=$((TPT-TPR))

  # echo "Received: $BWRX B/s    Sent: $BWTX B/s"
  #echo $((TX-TXPREV))
  #echo $MICSECS
  echo $((BWTX*8*1000000/MICSECS))
  echo Download

  sleep 600 
done
