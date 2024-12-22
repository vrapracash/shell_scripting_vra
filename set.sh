#!/bin/bash

set -ex  #setting the automatic exit, if we get error, set -ex is for debug

failure(){
    echo "failed at $1:$2"
}

trap 'failure "${LINENO}" "$BASH_COMMAND" ERR' #ERR is error in the signal

echo "Hello World Success"
echooo "Hello World Failure"
echo "Hellow World after Failure"