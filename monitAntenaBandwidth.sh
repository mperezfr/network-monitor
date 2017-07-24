#!/bin/bash

verbatim=1
DATEPATTERN="Date_in_seconds:"


host=$1
freq=$2
IF=$3
LOGFILE=$1.$2.log
rm `basename $LOGFILE .log`.full.log

if [ -z "$IF" ]; then
        IF=`ls -1 /sys/class/net/ | head -1`
fi

megas=2

while :; do
echo $DATEPATTERN `date +%s`

 
  #Download
  ssh $host "echo ${IF} Download Test > ${LOGFILE};
                  cat /sys/class/net/${IF}/statistics/tx_bytes>> ${LOGFILE};
                  echo \`adjtimex | grep tv_sec | awk '{print \$2}'\`\`adjtimex | grep tv_usec | awk '{printf (\"%06d\",\$2)}'\` >> ${LOGFILE};
                  dd if=/dev/zero bs=4096 count=$((1024*${megas}/4));
                  cat /sys/class/net/${IF}/statistics/tx_bytes>> ${LOGFILE};
                  echo \`adjtimex | grep tv_sec | awk '{print \$2}'\`\`adjtimex | grep tv_usec | awk '{printf (\"%06d\",\$2)}'\` >> ${LOGFILE};" | cat > /dev/null

  scp $host:$LOGFILE .
  ssh $host rm "${LOGFILE}"
  

  TXPREV=`sed -n '2p' < $LOGFILE`
  TPR=`sed -n '3p' < $LOGFILE`
  TX=`sed -n '4p' < $LOGFILE`
  TPT=`sed -n '5p' < $LOGFILE`

  let BWTX=$TX-$TXPREV
  let MICSECS=$((TPT-TPR))

  cat $LOGFILE >> `basename $LOGFILE .log`.full.log

  # echo "Received: $BWRX B/s    Sent: $BWTX B/s"
  #echo $((TX-TXPREV))
  #echo $MICSECS
  # bits per sec.
  echo $((BWTX*8*1000000/MICSECS)) bps 
  echo Download
  echo "Bytes transfered: $BWTX (`bc -l <<< \"scale=2;$BWTX/1000000\"` mbytes)"
  echo "Transfer Time: `bc -l <<< \"scale=2;$MICSECS/1000000\"` secs"



  #Upload
  
  dd if=/dev/zero bs=4096 count=$((1024*$megas/4)) | ssh $host "(echo ${IF} Upload Test > ${LOGFILE};
                                                                     cat /sys/class/net/${IF}/statistics/rx_bytes>> ${LOGFILE};
                                                                     echo \`adjtimex | grep tv_sec | awk '{print \$2}'\`\`adjtimex | grep tv_usec | awk '{printf (\"%06d\",\$2)}'\` >> ${LOGFILE};
                                                                     cat > /dev/null;
                                                                     cat /sys/class/net/${IF}/statistics/rx_bytes>> ${LOGFILE};
                                                                     echo \`adjtimex | grep tv_sec | awk '{print \$2}'\`\`adjtimex | grep tv_usec | awk '{printf (\"%06d\",\$2)}'\` >> ${LOGFILE};)"
  scp $host:$LOGFILE .
  ssh $host rm "${LOGFILE}"

  TXPREV=`sed -n '2p' < $LOGFILE`
  TPR=`sed -n '3p' < $LOGFILE`
  TX=`sed -n '4p' < $LOGFILE`
  TPT=`sed -n '5p' < $LOGFILE`

  let BWTX=$TX-$TXPREV
  let MICSECS=$((TPT-TPR))

  cat $LOGFILE >> `basename $LOGFILE .log`.full.log

  # echo "Received: $BWRX B/s    Sent: $BWTX B/s"
  #echo $((TX-TXPREV))
  #echo $MICSECS
  # bits per sec.
  echo $((BWTX*8*1000000/MICSECS)) bps 
  echo Upload
  echo "Bytes transfered: $BWTX (`bc -l <<< \"scale=2;$BWTX/1000000\"` mbytes)"
  echo "Transfer Time: `bc -l <<< \"scale=2;$MICSECS/1000000\"` secs"


  sleep 600 
done
