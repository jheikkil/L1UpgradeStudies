# L1UpgradeStudies code

This is the code to make turn on and efficiencies

Config file here
https://docs.google.com/spreadsheets/d/14CVVhA6ITSTmv0x0Z2BRJ7cLgMKabi6TWsDXbyffGBg/edit#gid=1735114236


## Setup (on lxplus)

1. Setup a recent CMSSW environment
1. Make sure you have root and fastjet in PATH
1. do `make` to compile everything
1. test run by typing `make TestRun`



## More information on the binaries

library/FillHistograms: makes all the histograms needed for later steps.  Input parameters as follows
1. input: comma-separated list of all root files
1. output: output file name (.root)
1. StoredGen: true/false.  Whether to use the gen jet info stored in the tree, or recluster on the fly
1. config: the config file to use

