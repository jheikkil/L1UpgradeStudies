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

There are a number of distributions in the middle field
1. PT: PT distribution without any eta restriction
1. PTEta15: PT in barrel
1. PTEtaLarge: PT outside barrel
1. Response: L1PT/GenPT
1. ResponseEta15: response in barrel
1. ResponseEtaLarge: response outside barrel
1. ResponsePT10: response with PT > 10
1. ResponsePT10Eta15: response with PT > 10, barrel
1. ResponsePT10EtaLarge: response with PT > 10, outside barrel
1. ResponsePT50: response with PT > 50
1. ResponsePT100: response with PT > 100
1. ResponsePT150: response with PT > 150
1. ResponsePT200: response with PT > 200
1. Eta: eta distribution
1. EtaPT3to5: eta with PT = 3-5
1. EtaPT3to6: eta with PT = 3-6
1. EtaPT3to10: eta with PT = 3-10
1. EtaPT3to15: eta with PT = 3-15
1. EtaPT15: eta with PT > 15
1. EtaPT20: eta with PT > 20
1. EtaPT25: eta with PT > 25
1. EtaPT30: eta with PT > 30
1. EtaPT100: eta with PT > 100
1. EtaPT200: eta with PT > 200
1. EtaDXY20: eta with DXY > 20
1. EtaDXY50: eta with DXY > 50
1. EtaDXY80: eta with DXY > 80
1. TkIso: isolation
1. TkIsoPT10: isolation with PT > 10
1. TkIsoPT20: isolation with PT > 20
1. TkIsoPT30: isolation with PT > 30
1. TkIsoPT40: isolation with PT > 40
1. TkIsoEta15: isolation within barrel
1. TkIsoEtaLarge: isolation outside barrel
1. TkIsoPT10Eta15: isolation within barrel, and PT > 10
1. TkIsoPT10EtaLarge: isolation outside barrel, and PT > 10
1. DR: matching DR distribution
1. DRPT10: matching DR, PT > 10
1. DRPT20: matching DR, PT > 20
1. DRPT50: matching DR, PT > 50
1. DREta15: matching DR inside barrel
1. DRPT10Eta15: matching DR inside barrel, PT > 10
1. DRPT20Eta15: matching DR inside barrel, PT > 20
1. DREtaLarge: matching DR outside barrel
1. DRPT10EtaLarge: matching DR outside barrel, PT > 10
1. DRPT20EtaLarge: matching DR outside barrel, PT > 20
1. DXY: DXY distribution
1. DXYPT15: DXY, PT > 15
1. DXYPT20: DXY, PT > 20
1. DXYPT30: DXY, PT > 30

























