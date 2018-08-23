#!/bin/bash

for i in `ls P*_calib.nii.gz | cut -d "_" -f 1-3`; do

echo $i

# TOPUP REORIENTED/FLIPPED CALIBRATION FILES
topup --imain=${i}_calib_reorient_flip.nii.gz --datain=acqparam.txt --config=b02b0.cnf --out=topup_${i}_calib --fout=${i}_calib_field.nii.gz --iout=${i}_calib_corrected.nii.gz --subsamp=1

# SPLIT REORIENTED/FLIPPED FMRI VOLUMES INTO AP/PA VOLUMES
mrconvert ${i}_rest_reorient_flip.nii.gz ${i}_rest_AP.nii.gz -coord 3 0:2:end 
mrconvert ${i}_rest_reorient_flip.nii.gz ${i}_rest_PA.nii.gz -coord 3 1:2:end

# APPLYTOPUP TO REORIENTED/FLIPPED/SPLIT FMRI VOLUMES
applytopup --imain=${i}_rest_AP.nii.gz --datain=acqparam.txt --inindex=1 --topup=topup_${i}_calib --out=${i}_rest_AP_corrected.nii.gz --method=jac
applytopup --imain=${i}_rest_PA.nii.gz --datain=acqparam.txt --inindex=2 --topup=topup_${i}_calib --out=${i}_rest_PA_corrected.nii.gz --method=jac

done

