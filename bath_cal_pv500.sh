#!/bin/bash
model=LASG-CESS/FGOALS-g2
expname=historical
id=r1i1p1

for model in BCC/bcc-csm1-1 BNU/BNU-ESM CCCma/CanESM2 CNRM-CERFACS/CNRM-CM5 IPSL/IPSL-CM5A-LR IPSL/IPSL-CM5A-MR CSIRO-QCCCE/CSIRO-Mk3-6-0 LASG-CESS/FGOALS-g2 MIROC/MIROC-ESM MIROC/MIROC-ESM-CHEM MOHC/HadGEM2-ES MRI/MRI-CGCM3 NASA-GISS/GISS-E2-H NASA-GISS/GISS-E2-R NCAR/CCSM4 NCC/NorESM1-M NOAA-GFDL/GFDL-CM3 NOAA-GFDL/GFDL-ESM2M NSF-DOE-NCAR/CESM1-CAM5;do
for expname in historical historicalNat historicalGHG;do
ncl model=\"$model\" \
    expname=\"$expname\" \
    id=\"$id\" \
    cal_pv500.ncl 
done
done
