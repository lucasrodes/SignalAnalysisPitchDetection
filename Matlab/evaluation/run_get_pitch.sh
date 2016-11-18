#!/bin/bash

GETF0="getf0snack -r 0.015"

for fwav in pitch_db/*.wav; do
    echo "$fwav ----"
    ff0=${fwav/.wav/.f0}
    $GETF0 $fwav $ff0 || (echo "Error in $GETF0 $fwav $ff0"; exit 1)
done

exit 0
