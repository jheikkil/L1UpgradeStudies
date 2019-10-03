# L1UpgradeStudies code

This is the code to make turn on and efficiencies

Config file [https://docs.google.com/spreadsheets/d/14CVVhA6ITSTmv0x0Z2BRJ7cLgMKabi6TWsDXbyffGBg/edit#gid=1735114236](here).
Copy paste the whole sheet into a text file, and feed the text file into the fill histogram executable to run things

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
1. TkElectron_*_00XX00: the distribution with gen-match, and with L1 PT > XX.  30 GeV = 003000, 10.5 GeV = 001050, etc.  The list is set by the "preset" column in the config file.

There are a number of distributions in the middle field
1. PT: PT distribution without any eta restriction
1. PTEta15: PT in barrel
1. PTEtaLarge: PT outside barrel
1. Response: L1PT/GenPT
1. ResponseEta15: response in barrel
1. ResponseEtaLarge: response outside barrel
1. ResponsePT`x`: response with PT > `x`, `x` = 10, 50, 100, 150, 200
1. ResponsePT10Eta15: response with PT > 10, barrel
1. ResponsePT10EtaLarge: response with PT > 10, outside barrel
1. Eta: eta distribution
1. EtaPT3to`x`: eta with PT = 3-`x`, `x` = 5, 6, 10, 15
1. EtaPT`x`: eta with PT > `x`, `x` = 15, 20, 25, 30, 100, 200
1. EtaDXY`x`: eta with DXY > `x`, `x` = 20, 50, 80
1. TkIso: isolation
1. TkIsoPT`x`: isolation with PT > `x`, `x` = 10, 20, 30, 40
1. TkIsoEta15: isolation within barrel
1. TkIsoEtaLarge: isolation outside barrel
1. TkIsoPT10Eta15: isolation within barrel, and PT > 10
1. TkIsoPT10EtaLarge: isolation outside barrel, and PT > 10
1. DR: matching DR distribution
1. DRPT`x`: matching DR, PT > `x`, `x` = 10, 20, 50
1. DREta15: matching DR inside barrel
1. DRPT10Eta15: matching DR inside barrel, PT > 10
1. DRPT20Eta15: matching DR inside barrel, PT > 20
1. DREtaLarge: matching DR outside barrel
1. DRPT10EtaLarge: matching DR outside barrel, PT > 10
1. DRPT20EtaLarge: matching DR outside barrel, PT > 20
1. DXY: DXY distribution
1. DXYPT`x`: DXY, PT > `x`, `x` = 15, 20, 30

So... If you want...

1. Matching efficiency vs PT: TkElectron_PT_000000 / TkElectronNoMatch_PT_000000
1. Matching efficiency vs eta: TkElectron_Eta_000000 / TkElectronNoMatch_Eta_000000
1. Turn on with threhsold 15: TkElectron_PT_001500 / TkElectron_PT_000000
1. Isolation distritbuion: TkElectron_TkIso_000000

For things involving isolation, sometimes you need to get it from different folders.  For example

1. Matching efficiency vs PT for TkIsoElectron: TkIsoElectron_PT_000000 / TkElectronIsoNoMatch_PT_000000















