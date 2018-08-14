#!/bin/bash

for i in `ls sub*_fmri-calib_bold.nii.gz | cut -d "_" -f 1`;
do 

echo $i

j=$((`fslinfo ${i}_task-rest_bold_flipped.nii.gz | grep -w 'dim4' | awk '{ print $2}'` - 1))

echo $(seq 0 2 $((`fslinfo ${i}_task-rest_bold_flipped.nii.gz | grep -w 'dim4' | awk '{ print $2}'` - 1))) | awk '{gsub(/ /,",")}; 1' > ${j}even.list
echo $(seq 1 2 $((`fslinfo ${i}_task-rest_bold_flipped.nii.gz | grep -w 'dim4' | awk '{ print $2}'` - 1))) | awk '{gsub(/ /,",")}; 1' > ${j}odd.list

mrconvert ${i}_task-rest_bold_flipped.nii.gz ${i}_AP_flipped.nii.gz -coord 3 `cat ${j}even.list` 
mrconvert ${i}_task-rest_bold_flipped.nii.gz ${i}_PA_flipped.nii.gz -coord 3 `cat ${j}odd.list`

done
