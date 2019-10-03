# L1UpgradeStudies code

This is the code to make turn on and efficiencies

Config file here
https://docs.google.com/spreadsheets/d/14CVVhA6ITSTmv0x0Z2BRJ7cLgMKabi6TWsDXbyffGBg/edit#gid=1735114236

The code is done in two parts.  First part is an executable to generate all the histograms.  The second part is to take the histograms and make efficiencies, turn-ons, and scalings.





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


## Histogram structure

Each object is in its own directory.  Within each directory, there are many many histograms.  Let's take TkElectron as example.  The naming convention is
1. TkElectronNoMatch_*_000000: The distribution without gen-match
1. TkElectron_*_000000: the distribution with gen-match, but no L1 PT requirement
1. TkElectron_*_00XX00: the distribution with gen-match, and with L1 PT > XX.  30 GeV = 003000, 10.5 GeV = 001050, etc.



