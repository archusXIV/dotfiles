#!/bin/sh

gputemp="$(nvidia-smi --format=nounits,csv,noheader --query-gpu=temperature.gpu | xargs echo)"

if [ -n "$(pidof nvidia-persistenced)" ]; then
    echo "$gputemp°C"
else
    echo "no nvidia driver installed"
fi

exit
