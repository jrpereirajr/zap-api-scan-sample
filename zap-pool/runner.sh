#!/bin/bash
FILE=/irisdev/app/zap-pool/in/script.sh
if test -f "$FILE"; then
    echo "$FILE exists."
    sh $FILE
    rm $FILE
fi