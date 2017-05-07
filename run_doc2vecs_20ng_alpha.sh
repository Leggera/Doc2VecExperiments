#!/bin/bash

function normalize_text {
  awk '{print tolower($0);}' < $1 | sed -e 's/\./ \. /g' -e 's/<br \/>/ /g' -e 's/"/ " /g' \
  -e 's/,/ , /g' -e 's/(/ ( /g' -e 's/)/ ) /g' -e 's/\!/ \! /g' -e 's/\?/ \? /g' \
  -e 's/\;/ \; /g' -e 's/\:/ \: /g' > $1-norm
}

alphas=('-alpha 0.01' '-alpha 0.015' '-alpha 0.020')
default_parameters=('-size 150 -alpha 0.05 -window 10 -negative 25 -iter 25 -threads 1 -min_count 5')
default_models=('-cbow 0 -sample 1e-2' '-cbow 1 -sample 1e-4')
mkdir time_p2v_20ng_mc5
time_fold="time_p2v_20ng_mc5/"
mkdir space_p2v_20ng_mc5
space_fold="space_p2v_20ng_mc5/"
for model in "${default_models[@]}"; do
	for alpha in "${alphas[@]}"; do
	    delete=("-alpha 0.05")
	    d_p=${default_parameters[@]/$delete}
	    #echo $d_p
	    #echo $alpha
	    d2v_out="doc2vec ""$model""$alpha"".txt"
	    d2v_t="$time_fold""time_""$d2v_out"
	    (time (python3 run_doc2vec_20ng.py  -output "$space_fold""$d2v_out" $alpha $model $d_p >> "$d2v_t")) &>> "$d2v_t" &
	done
done
wait
