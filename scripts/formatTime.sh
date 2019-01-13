#!/bin/bash

time=$1; min=0; sec=0;
if (( $time > 59 )); then
    (( sec=time%60 ));
    (( time=time/60 ));
    if (( $time > 59 )); then
        (( min=time%60 ));
        (( time=time/60 ));
    else
        ((min=time));
    fi
else
    ((sec=time));
fi
if (( $sec < 10 )); then
    sec="0$sec";
fi
echo "$min:$sec";