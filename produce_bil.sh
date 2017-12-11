#!/bin/bash 

# Takes a list of all realisations and produces the .bil files for susceptibility

run_dir=$1
list_runs=`cat $2`

for run_name in $list_runs
do
  for realisation_path in `find  $run_dir/$run_name/GM/Sim/Data/$run_name -type d -name ""$run_name"_HYP*"`
  do
    python3 /usr/bin/gfail /home/nesi00213/groundfailure/config/zhu_2016_general_susceptibility_nz-specific-vs30.ini $realisation_path/grid.xml --set-bounds 'zoom, pgv, 0' --hdf5 -o /home/lukelongworth/BILs/Liquefaction/General_NZ/ -c /home/nesi00213/groundfailure/config -d /home/nesi00213/groundfailure/liquefaction_model --gis
    python3 /usr/bin/gfail /home/nesi00213/groundfailure/config/zhu_2016_general_susceptibility_topo-based-vs30.ini $realisation_path/grid.xml --set-bounds 'zoom, pgv, 0' --hdf5 -o /home/lukelongworth/BILs/Liquefaction/General_topo/ -c /home/nesi00213/groundfailure/config -d /home/nesi00213/groundfailure/liquefaction_model --gis
    python3 /usr/bin/gfail /home/nesi00213/groundfailure/config/zhu_2016_coastal_susceptibility_nz-specific-vs30.ini $realisation_path/grid.xml --set-bounds 'zoom, pgv, 0' --hdf5 -o /home/lukelongworth/BILs/Liquefaction/Coastal_NZ/ -c /home/nesi00213/groundfailure/config -d /home/nesi00213/groundfailure/liquefaction_model --gis
    python3 /usr/bin/gfail /home/nesi00213/groundfailure/config/zhu_2016_coastal_susceptibility_topo-based-vs30.ini $realisation_path/grid.xml --set-bounds 'zoom, pgv, 0' --hdf5 -o /home/lukelongworth/BILs/Liquefaction/Coastal_topo/ -c /home/nesi00213/groundfailure/config -d /home/nesi00213/groundfailure/liquefaction_model --gis
  
    python3 /usr/bin/gfail /home/nesi00213/groundfailure/config/jessee_2017_susceptibility.ini $realisation_path/grid.xml --set-bounds 'zoom, pgv, 0' --hdf5 -o /home/lukelongworth/BILs/Landslide/ -c /home/nesi00213/groundfailure/config -d /home/nesi00213/groundfailure/liquefaction_model --gis
  done
done

