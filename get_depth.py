# This code finds the depth of a given realisation
# It is designed to work with the cybershake_run_liqls.sh in /home/lukelongworth
# Inputs: The filepath to the Sim/Data of a particular realisation
# Outputs: A float
import ConfigParser
import os
import argparse

#Initialisation
config = ConfigParser.RawConfigParser()
parser = argparse.ArgumentParser()
parser.add_argument("rp")

args = parser.parse_args()
realisation_path = args.rp

#Get the data
os.chdir(realisation_path) #Go to relevant directory
config.read("pp_config.cfg") #Open the relevant config file
print config.get("plotGMPE", "Ztor") #Grab and print the depth