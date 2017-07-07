#!/bin/bash

now=`date +%s`

HOST=$1

# Al inicio y Cada X minutos????

#Station name
snmpwalk -v 1 -c public $HOST .1.3.6.1.4.1.41112.1.4.7.1.2
#SSID
snmpwalk -v 1 -c public $HOST .1.3.6.1.4.1.41112.1.4.5.1.2
# Channel Width
snmpwalk -v 1 -c public $HOST .1.3.6.1.4.1.41112.1.4.5.1.14
# Operating frequency	
snmpwalk -v 1 -c public $HOST .1.3.6.1.4.1.41112.1.4.1.1.4


#ubntRadioMode	.1.3.6.1.4.1.41112.1.4.1.1.2
#Transmit power	.1.3.6.1.4.1.41112.1.4.1.1.7
#Antenna	.1.3.6.1.4.1.41112.1.4.1.1.9
#Channel Width	.1.3.6.1.4.1.41112.1.4.5.1.14


# Cada 5 segundos comprueba el CCQ y demás


while :; do
date +%s
#CCQ
echo CCQ    `snmpwalk -v 1 -c public $HOST .1.3.6.1.4.1.41112.1.4.5.1.7`
#Signal strength
echo Signal `snmpwalk -v 1 -c public $HOST .1.3.6.1.4.1.41112.1.4.5.1.5`
# Noise floor	
echo Noise  `snmpwalk -v 1 -c public $HOST .1.3.6.1.4.1.41112.1.4.5.1.8`
#TX rate	
echo TX     `snmpwalk -v 1 -c public $HOST .1.3.6.1.4.1.41112.1.4.5.1.9`
#RX rate	
echo RX    `snmpwalk -v 1 -c public $HOST .1.3.6.1.4.1.41112.1.4.5.1.10`
# Operating frequency	
echo Freq   `snmpwalk -v 1 -c public $HOST .1.3.6.1.4.1.41112.1.4.1.1.4`

sleep 5 
done
