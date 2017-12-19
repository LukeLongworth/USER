#!/bin/bash

# This script takes a .txt file such as the ones produced by Cybershake and converts them to a collated .csv file with information on expected effect over time
# USAGE: bash /home/nesi00213/groundfailure/scripts/expected_effect.sh /path/to/folder/containing/.txtfile "Name of .txt file" Number_of_years_over_which_to_analyse list,of,probabilities,from,largest,to,smallest The_ini_file_that_the_analysis_will_use.ini
# EXAMPLE: bash /home/nesi00213/groundfailure/scripts/expected_effect.sh /home/lukelongworth/Test_folder HazMapData.txt 50 0.8,0.5,0.2,0.1,0.08,0.06,0.04,0.02,0.01,0.005,0.002 zhu_2016_general_probability_nz-specific-vs30.ini
# Defaults: $1 and $2 are compulsory inputs, $3 will default to 50, $4 will default to 0.8,0.5,0.25,0.1,0.08,0.06,0.04,0.02,0.01,0.005, $5 will default to zhu_2016_general_probability_nz-specific-vs30.ini

# Initialise variables
source_folder=$1 #"/home/lukelongworth"
source_file=$2 # "HazCurveResults.txt" Should be in source_folder
years=${3:-50.0} # 50
probabilities=${4:-0.8,0.5,0.25,0.1,0.08,0.06,0.04,0.02,0.01,0.005} #0.8,0.5,0.25,0.1,0.08,0.06,0.04,0.02,0.01,0.005
ini=${5:-zhu_2016_general_probability_nz-specific-vs30.ini}

mkdir $source_folder/HazMapData
mkdir $source_folder/HazMapData/xyz

# Firstly produce a csv
cd $source_folder
cp /home/lukelongworth/non_uniform_whole_nz-hh400.ll $source_folder # This is probably not feasible long-term, it should be called from elsewhere
python /home/lukelongworth/GroundFailure/scripts/haz_curve_prob_export_2.py -i $source_folder -p $probabilities -y $years -o $source_folder/HazMapData $source_file
echo The .txt files have been produced from the master file $source_file
cd HazMapData
# Then a for loop
for f in pgv_*.txt
do
  echo Take $f as the probability
  # Then take this csv and runs grd2grid
  python /home/nesi00213/groundfailure/haz_analysis/grd2grid.py $source_folder/HazMapData/$f $f $source_folder/HazMapData/grids/
  echo produced the grid.xml file

  python3 /usr/bin/gfail $ini $source_folder/HazMapData/grids/grid.xml --set-bounds 'zoom, pgv, 0' --hdf5 -o $source_folder/HazMapData/grids -c /home/nesi00213/groundfailure/config/ -d /home/nesi00213/groundfailure/liquefaction_model/ #Currently this will ONLY work with liquefaction config files
  echo produced the h5 files

  python /home/nesi00213/groundfailure/gen_gf_surface.py -t '' -o $source_folder/HazMapData/xyz/$f.xyz $source_folder/HazMapData/grids/$f/*.hdf5 --keep-nans
  echo produced the xyz files
  cp $source_folder/HazMapData/grids/grid.xml $source_folder/HazMapData/grids/$f/
  echo We have finished analysing the probability of $f

done

cp /home/lukelongworth/HazMapData/xyz/collate2.py $source_folder/HazMapData/xyz/ # Same as above, this is likely not suitable long-term, should be copied from elsewhere
cd $source_folder/HazMapData/xyz/
python $source_folder/HazMapData/xyz/collate2.py -p $probabilities > $source_folder/final_collation.csv
echo Produced collation

