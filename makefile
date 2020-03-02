default: all

all: commoncode libraries executables

CommonCode = library/L1Classes.so library/TauHelperFunctions3.o library/DrawRandom2.o library/Messenger.o
Libraries  = library/Histograms.o library/HelperFunctions.o

commoncode: $(CommonCode)	

libraries: $(Libraries)

executables: binary/FillHistograms binary/PlotComparison binary/MakeScalingPlot binary/ExportTextFile

library/L1Classes.so: include/L1Classes.h include/L1LinkDef.h
	mkdir -p library
	rootcint -f source/L1Classes.cpp -c include/L1Classes.h include/L1LinkDef.h
	g++ `root-config --cflags` source/L1Classes.cpp -o library/L1Classes.o -I. -c -fpic
	g++ -shared -o library/L1Classes.so library/L1Classes.o
	ln -s -f source/L1Classes_rdict.pcm .

library/TauHelperFunctions3.o: source/TauHelperFunctions3.cpp include/TauHelperFunctions3.h
	mkdir -p library
	g++ source/TauHelperFunctions3.cpp -Iinclude -o library/TauHelperFunctions3.o -c

library/DrawRandom2.o: source/DrawRandom2.cpp include/DrawRandom2.h
	mkdir -p library
	g++ source/DrawRandom2.cpp -Iinclude -o library/DrawRandom2.o -c

library/Messenger.o: source/Messenger.cpp include/Messenger.h
	mkdir -p library
	g++ source/Messenger.cpp -Iinclude -o library/Messenger.o -c `root-config --cflags` -g

library/Histograms.o: source/Histograms.cpp include/Histograms.h
	mkdir -p library
	g++ source/Histograms.cpp -Iinclude -o library/Histograms.o -c `root-config --cflags` -g

library/HelperFunctions.o: source/HelperFunctions.cpp include/HelperFunctions.h
	mkdir -p library
	g++ source/HelperFunctions.cpp -Iinclude -o library/HelperFunctions.o -c `fastjet-config --cxxflags` `root-config --cflags` -g

binary/FillHistograms: source/FillHistograms.cpp library/Histograms.o library/HelperFunctions.o
	mkdir -p binary
	g++ source/FillHistograms.cpp -Iinclude -o binary/FillHistograms $(CommonCode) \
		library/Histograms.o library/HelperFunctions.o \
		`fastjet-config --cxxflags --libs` `root-config --cflags --libs` -g

binary/PlotComparison: source/PlotComparison.cpp
	mkdir -p binary
	g++ source/PlotComparison.cpp -Iinclude -o binary/PlotComparison \
		`root-config --cflags --libs`

binary/MakeScalingPlot: source/MakeScalingPlot.cpp
	mkdir -p binary
	g++ source/MakeScalingPlot.cpp -Iinclude -o binary/MakeScalingPlot \
		`root-config --cflags --libs`

binary/ExportTextFile: source/ExportTextFile.cpp
	mkdir -p binary
	g++ source/ExportTextFile.cpp -Iinclude -o binary/ExportTextFile \
		`root-config --cflags --libs`

TestRun: TestRunPart1 TestRunPart2

TestRunPart1: binary/FillHistograms
	mkdir -p output
	binary/FillHistograms --input `ls $(DYLL_V10p7)/* | head -n 1 | tr '\n' ',' | sed "s/,$$//g"` \
		--output output/DYLL_V10p7_06022020_1stFileOnly.root --StoredGen true --config config/myconfig.config
	
TestRunPart2: binary/PlotComparison binary/MakeScalingPlot binary/ExportTextFile
	mkdir -p pdf
	binary/PlotComparison \
		--label "EGElectron (V10.7)","TkElectron (V10.7)","TkIsoElectron (V10.7)" \
		--file output/DYLL_V10p7.root,output/DYLL_V10p7.root,output/DYLL_V10p7.root \
		--numerator "EGTrackIDIso_PTEta15_000000","TkElectronTrackIDIso_PTEta15_000000","TkIsoElectron_PTEta15_000000" \
		--denominator "auto","auto","TkElectronIsoNoMatch_PTEta15_000000" \
		--title ";p_{T};Efficiency" --xmin 0 --xmax 40 --output pdf/V10p7_EGComparison.pdf \
		--legendx 0.45 --legendy 0.20
	mkdir -p dh
	binary/MakeScalingPlot --input output/DYLL_V10p7.root --output pdf/V10p7_EGScaling.pdf \
		--curves dh/V10p7_Scaling.dh \
		--reference 0.95 --DoEG true --DoEGTrack true --DoElectron true --DoIsoElectron true
	binary/MakeScalingPlot --input output/DYLL_V10p7.root --output pdf/V10p7_MuonScaling.pdf \
		--curves dh/V10p7_Scaling.dh \
		--reference 0.95 --DoTkMuon true
	mkdir -p txt
	binary/ExportTextFile --input dh/V10p7_Scaling.dh --output txt/V10p7_Scaling.txt

DYLL_V9p3 = /eos/cms/store/group/cmst3/group/l1tr/cepeda/triggerntuples160/RelValZEE_14/crab_ZEE_noageing_106_V9_3//190910_103305/0000//
DYLL_V10p7 = /eos/cms/store/group/cmst3/group/l1tr/cepeda/triggerntuplesTDR/DYToLL_V10_7/NTP/v1//
DYLL_V7p5p2 = /eos/cms/store/cmst3/group/l1tr/cepeda/triggerntuples10X/DYToLL_M-50_14TeV_TuneCP5_pythia8/crab_DYLL_200PU_V7_5_2/190324_103140/0000//
DYLL_V10    = /eos/cms/store/group/cmst3/group/l1tr/cepeda/triggerntuplesTDR/DYToLL_V10_1/NTP/v1/
PrivateSample    = /afs/cern.ch/work/p/pmeiring/private/CMS/CMSSW_10_6_1_patch2/src/L1Trigger/L1TCommon/test/PrivateSamples/
SingleEle = /eos/cms/store/user/jheikkil/ntuples/SingleE_FlatPt-2to100/SingleE_FlatPt-2to100_PU200_v47/200224_161731/0000
SinglePhoton = /eos/cms/store/user/jheikkil/ntuples/SinglePhoton_FlatPt-8to150/SinglePhoton_FlatPt-8to150_PU200_v47/200225_161654/0000/
SingleEle2 = /eos/cms/store/user/jheikkil/TRG3/SingleE_FlatPt-2to100/SingleE_FlatPt-2to100_PU200_v47/200226_134632/0000/
MariaDY = ~cepeda/public/L1NtuplePhaseII_MTD_EGCheck.root

OutputHists = output/MariaDY.root
OutputHists2 = output/DYLL_V10p7_0702_20_Zincl.root
OutputEOS = /eos/user/j/jheikkil/www/L1Trigger/SingleEle
IndexPHP = /eos/user/j/jheikkil/www/L1Trigger/index.php

myfillhistograms: binary/FillHistograms
	mkdir -p output
	binary/FillHistograms --input `ls $(SingleEle2)/* | head -n 1 | tr '\n' ',' | sed "s/,$$//g"` \
		--output $(OutputHists) --StoredGen true --tree true --config config/mycustom.config

MatchingEff_EG_TkE_PT_TESTI: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron (V10.7)","TkElectronV2 (V10.7)" \
		--file $(OutputHists),$(OutputHists) \
		--numerator "EGTrackID_PT_000000","TkElectronV2TrackID_PT_000000" \
		--denominator "auto","auto" \
		--title ";p^{gen}_{T};Efficiency" --xmin 0 --xmax 50 --color 1,2 --output $(OutputEOS)/MatchingEff_EG_TkE_PT_TESTI.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

	
MatchingEff_EG_TkE_PT: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron (V10.7)","TkElectronV2 (V10.7)" \
		--file $(OutputHists),$(OutputHists) \
		--numerator "EGTrackID_PT_000000","TkElectronV2TrackID_PT_000000" \
		--denominator "EGTrackIDNoMatch_PT_000000","TkElectronV2TrackIDNoMatch_PT_000000" \
		--title ";p^{gen}_{T};Efficiency" --xmin 0 --xmax 100 --color 1,2 --output $(OutputEOS)/MatchingEff_EG_TkE_PT.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

MatchingEff_EG_TkE_PT_Zboson: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron (V10.7)","TkElectronV2 (V10.7)" \
		--file $(OutputHists),$(OutputHists) \
		--numerator "EGTrackIDZ_PT_000000","TkElectronV2TrackIDZ_PT_000000" \
		--denominator "EGTrackIDZNoMatch_PT_000000","TkElectronV2TrackIDZNoMatch_PT_000000" \
		--title ";p^{gen}_{T};Efficiency" --xmin 0 --xmax 50 --color 1,2 --output $(OutputEOS)/MatchingEff_EG_TkE_PT_Zboson_50.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

MatchingEff_EG_TkE_PT_ZbosonISO: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron (V10.7)","TkElectronV2 (V10.7)" \
		--file $(OutputHists),$(OutputHists) \
		--numerator "EGTrackIDIsoZ_PT_000000","TkElectronV2TrackIDIsoZ_PT_000000" \
		--denominator "EGTrackIDIsoZNoMatch_PT_000000","TkElectronV2TrackIDIsoZNoMatch_PT_000000" \
		--title ";p^{gen}_{T};Efficiency" --xmin 0 --xmax 100 --color 1,2 --output $(OutputEOS)/MatchingEff_EG_TkE_PT_ZbosonISO.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

MatchingEff_EG_Eta_PTbinned: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php	
	binary/PlotComparison \
		--label "5 < pT < 10","10 < pT < 20","20 < pT < 30","30 < pT < 40" \
		--file $(OutputHists),$(OutputHists),$(OutputHists),$(OutputHists) \
		--numerator "EGTrackID_EtaPT5to10_000000","EGTrackID_EtaPT10to20_000000","EGTrackID_EtaPT20to30_000000","EGTrackID_EtaPT30to40_000000" \
		--denominator "auto","auto","auto","auto" \
		--title "EGElectron (V10.7);#eta^{gen};Efficiency" --xmin -3 --xmax 3 --output $(OutputEOS)/MatchingEff_EG_Eta_PTbinned.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

MatchingEff_TkE_Eta_PTbinned: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "5 < pT < 10","10 < pT < 20","20 < pT < 30","30 < pT < 40" \
		--file $(OutputHists),$(OutputHists),$(OutputHists),$(OutputHists) \
		--numerator "TkElectronV2TrackID_EtaPT5to10_000000","TkElectronV2TrackID_EtaPT10to20_000000","TkElectronV2TrackID_EtaPT20to30_000000","TkElectronV2TrackID_EtaPT30to40_000000" \
		--denominator "auto","auto","auto","auto" \
		--title "TkElectronV2 (V10.7);#eta^{gen};Efficiency" --xmin -3 --xmax 3 --output $(OutputEOS)/MatchingEff_TkE_Eta_PTbinned.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

TurnOn_EG_TkE_PT35_Etabinned: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron","TkElectronV2" \
		--file $(OutputHists),$(OutputHists) \
		--numerator "EGTrackID_EtaPT35_002500","TkElectronV2TrackID_EtaPT35_002500" \
		--denominator "EGTrackIDNoMatch_EtaPT35_000000","TkElectronV2TrackIDNoMatch_EtaPT35_000000" \
		--title ";#eta^{gen};Efficiency" --xmin -3 --xmax 3 --ymin 0.6 --ymax 1.1 --color 1,2 --output $(OutputEOS)/TurnOn_EG_TkE_PT35_NoMatch_Etabinned_v2.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

TurnOn_EG_DYvsEle_PT40_Etabinned: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "SingleEle","DY" \
		--file $(OutputHists),$(OutputHists2) \
		--numerator "EGTrackID_EtaPT40_002500","EGTrackID_EtaPT40_002500" \
		--denominator "EGTrackIDNoMatch_EtaPT40_000000","EGTrackIDNoMatch_EtaPT40_000000" \
		--title ";#eta^{gen};Efficiency" --xmin -3 --xmax 3 --ymin 0.6 --ymax 1.1 --color 1,2 --output $(OutputEOS)/TurnOn_EG_DYvsEle_PT40_NoMatch_Etabinned.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

TurnOn_TkEle_DYvsEle_PT40_Etabinned: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "SingleEle","DY" \
		--file $(OutputHists),$(OutputHists2) \
		--numerator "TkElectronV2TrackID_EtaPT40_002500","TkElectronV2TrackID_EtaPT40_002500" \
		--denominator "TkElectronV2TrackIDNoMatch_EtaPT40_000000","TkElectronV2TrackIDNoMatch_EtaPT40_000000" \
		--title ";#eta^{gen};Efficiency" --xmin -3 --xmax 3 --ymin 0.6 --ymax 1.1 --color 1,2 --output $(OutputEOS)/TurnOn_TkEle_DYvsEle_PT40_NoMatch_Etabinned.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10


TurnOn_EG_TkE_PT40_Etabinned: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron","TkElectronV2" \
		--file $(OutputHists),$(OutputHists) \
		--numerator "EGTrackID_EtaPT40_002500","TkElectronV2TrackID_EtaPT40_002500" \
		--denominator "EGTrackIDNoMatch_EtaPT40_000000","TkElectronV2TrackIDNoMatch_EtaPT40_000000" \
		--title ";#eta^{gen};Efficiency" --xmin -3 --xmax 3 --ymin 0.6 --ymax 1.1 --color 1,2 --output $(OutputEOS)/TurnOn_EG_TkE_PT40_NoMatch_Etabinned.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

MatchingEff_EG_DYvsEle_PT25: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "SingleEle","DY" \
		--file $(OutputHists),$(OutputHists2) \
		--numerator "EGTrackID_PT_002500","EGTrackID_PT_002500" \
		--denominator "EGTrackIDNoMatch_PT_000000","EGTrackIDNoMatch_PT_000000" \
		--title ";p^{gen}_{T};Efficiency" --xmin 0 --xmax 100 --color 1,2 --output $(OutputEOS)/MatchingEff_EG_DYvsEle_PT_L1_25.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

MatchingEff_TkEle_DYvsEle_PT25: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "SingleEle","DY" \
		--file $(OutputHists),$(OutputHists2) \
		--numerator "TkElectronV2TrackID_PT_002500","TkElectronV2TrackID_PT_002500" \
		--denominator "TkElectronV2TrackIDNoMatch_PT_000000","TkElectronV2TrackIDNoMatch_PT_000000" \
		--title ";p^{gen}_{T};Efficiency" --xmin 0 --xmax 100 --color 1,2 --output $(OutputEOS)/MatchingEff_TkEle_DYvsEle_PT_L1_25.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10


MatchingEff_EG_DYvsEle_PT: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "SingleEle","DY" \
		--file $(OutputHists),$(OutputHists2) \
		--numerator "EGTrackID_PT_000000","EGTrackID_PT_000000" \
		--denominator "EGTrackIDNoMatch_PT_000000","EGTrackIDNoMatch_PT_000000" \
		--title ";p^{gen}_{T};Efficiency" --xmin 0 --xmax 100 --color 1,2 --output $(OutputEOS)/MatchingEff_EG_DYvsEle_PT.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

MatchingEff_TkEle_DYvsEle_PT: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "SingleEle","DY" \
		--file $(OutputHists),$(OutputHists2) \
		--numerator "TkElectronV2TrackID_PT_000000","TkElectronV2TrackID_PT_000000" \
		--denominator "TkElectronV2TrackIDNoMatch_PT_000000","TkElectronV2TrackIDNoMatch_PT_000000" \
		--title ";p^{gen}_{T};Efficiency" --xmin 0 --xmax 100 --color 1,2 --output $(OutputEOS)/MatchingEff_TkEle_DYvsEle_PT.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

MatchingEff_EG_TkE_PT_barrel: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron | 0 <#eta < 1.479","TkElectronV2  | 0 <#eta < 1.479" \
		--file $(OutputHists),$(OutputHists) \
		--numerator "EGTrackID_PTEta0to1p479_000000","TkElectronV2TrackID_PTEta0to1p479_000000" \
		--denominator "EGTrackIDNoMatch_PTEta0to1p479_000000","TkElectronV2TrackIDNoMatch_PTEta0to1p479_000000" \
		--title ";p^{gen}_{T};Efficiency" --xmin 0 --xmax 50 --output $(OutputEOS)/MatchingEff_EG_TkE_PT_Etabinned.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10


MatchingEff_EG_TkE_PT_Etabinned: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron | 0 <#eta < 1.479","EGElectron | 1.479 <#eta < 2.4","TkElectronV2  | 0 <#eta < 1.479","TkElectronV2  | 1.479 <#eta < 2.4" \
		--file $(OutputHists),$(OutputHists),$(OutputHists),$(OutputHists) \
		--numerator "EGTrackID_PTEta0to1p479_000000","EGTrackID_PTEta1p479to2p8_000000","TkElectronV2TrackID_PTEta0to1p479_000000","TkElectronV2TrackID_PTEta1p479to2p8_000000" \
		--denominator "auto","auto","auto","auto" \
		--title ";p^{gen}_{T};Efficiency" --xmin 0 --xmax 50 --output $(OutputEOS)/MatchingEff_EG_TkE_PT_Etabinned.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

MatchingEff_EG_TkE_PT_Etabinned_Zboson: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron | 0 <#eta < 1.479","EGElectron | 1.479 <#eta < 2.4","TkElectronV2  | 0 <#eta < 1.479","TkElectronV2  | 1.479 <#eta < 2.4" \
		--file $(OutputHists),$(OutputHists),$(OutputHists),$(OutputHists) \
		--numerator "EGTrackIDZ_PTEta0to1p479_000000","EGTrackIDZ_PTEta1p479to2p8_000000","TkElectronV2TrackIDZ_PTEta0to1p479_000000","TkElectronV2TrackIDZ_PTEta1p479to2p8_000000" \
		--denominator "auto","auto","auto","auto" \
		--title ";p^{gen}_{T};Efficiency" --xmin 0 --xmax 50 --output $(OutputEOS)/MatchingEff_EG_TkE_PT_Etabinned_Zboson.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

MatchingEff_EG_TkE_PT_Etabinned_ZbosonISO: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron | 0 <#eta < 1.479","EGElectron | 1.479 <#eta < 2.4","TkElectronV2  | 0 <#eta < 1.479","TkElectronV2  | 1.479 <#eta < 2.4" \
		--file $(OutputHists),$(OutputHists),$(OutputHists),$(OutputHists) \
		--numerator "EGTrackIDIsoZ_PTEta0to1p479_000000","EGTrackIDIsoZ_PTEta1p479to2p8_000000","TkElectronV2TrackIDIsoZ_PTEta0to1p479_000000","TkElectronV2TrackIDIsoZ_PTEta1p479to2p8_000000" \
		--denominator "auto","auto","auto","auto" \
		--title ";p^{gen}_{T};Efficiency" --xmin 0 --xmax 50 --output $(OutputEOS)/MatchingEff_EG_TkE_PT_Etabinned_ZbosonISO.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10



TurnOn_EG_TkE_PT35_Etabinned_Zboson: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron","TkElectronV2" \
		--file $(OutputHists),$(OutputHists) \
		--numerator "EGTrackIDZ_EtaPT35_002500","TkElectronV2TrackIDZ_EtaPT35_002500" \
		--denominator "EGTrackIDZNoMatch_EtaPT35_000000","TkElectronV2TrackIDZNoMatch_EtaPT35_000000" \
		--title ";#eta^{gen};Efficiency" --xmin -3 --xmax 3 --ymin 0.6 --ymax 1.1 --color 1,2 --output $(OutputEOS)/TurnOn_EG_TkE_PT35_NoMatch_Etabinned_Zboson.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

TurnOn_EG_TkE_PT35_Etabinned_ZbosonISO: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron","TkElectronV2" \
		--file $(OutputHists),$(OutputHists) \
		--numerator "EGTrackIDIsoZ_EtaPT35_002500","TkElectronV2TrackIDIsoZ_EtaPT35_002500" \
		--denominator "EGTrackIDIsoZNoMatch_EtaPT35_000000","TkElectronV2TrackIDIsoZNoMatch_EtaPT35_000000" \
		--title ";#eta^{gen};Efficiency" --xmin -3 --xmax 3 --ymin 0.6 --ymax 1.1 --color 1,2 --output $(OutputEOS)/TurnOn_EG_TkE_PT35_NoMatch_Etabinned_ZbosonISO.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10


TurnOn_EG_TkE_Etabinned: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron","TkElectronV2" \
		--file $(OutputHists),$(OutputHists) \
		--numerator "EGTrackID_Eta_000000","TkElectronV2TrackID_Eta_000000" \
		--denominator "EGTrackIDNoMatch_Eta_000000","TkElectronV2TrackIDNoMatch_Eta_000000" \
		--title ";#eta^{gen};Efficiency" --xmin -3 --xmax 3 --ymin 0.0 --ymax 1.1 --color 1,2 --output $(OutputEOS)/TurnOn_EG_TkE_NoMatch_Etabinned.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10


TurnOn_EG_TkE_Etabinned_Zboson: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron","TkElectronV2" \
		--file $(OutputHists),$(OutputHists) \
		--numerator "EGTrackIDZ_Eta_000000","TkElectronV2TrackIDZ_Eta_000000" \
		--denominator "EGTrackIDZNoMatch_Eta_000000","TkElectronV2TrackIDZNoMatch_Eta_000000" \
		--title ";#eta^{gen};Efficiency" --xmin -3 --xmax 3 --ymin 0.0 --ymax 1.1 --color 1,2 --output $(OutputEOS)/TurnOn_EG_TkE_NoMatch_Etabinned_Zboson.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

TurnOn_EG_TkE_Etabinned_ZbosonISO: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "EGElectron","TkElectronV2" \
		--file $(OutputHists),$(OutputHists) \
		--numerator "EGTrackIDIsoZ_Eta_000000","TkElectronV2TrackIDIsoZ_Eta_000000" \
		--denominator "EGTrackIDIsoZNoMatch_Eta_000000","TkElectronV2TrackIDIsoZNoMatch_Eta_000000" \
		--title ";#eta^{gen};Efficiency" --xmin -3 --xmax 3 --ymin 0.0 --ymax 1.1 --color 1,2 --output $(OutputEOS)/TurnOn_EG_TkE_NoMatch_Etabinned_ZbosonISO.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10


MatchingEff_EG_Eta_PTbinned_Zboson: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "5 < pT < 10","10 < pT < 20","20 < pT < 30","30 < pT < 40" \
		--file $(OutputHists),$(OutputHists),$(OutputHists),$(OutputHists) \
		--numerator "EGTrackIDZ_EtaPT5to10_000000","EGTrackIDZ_EtaPT10to20_000000","EGTrackIDZ_EtaPT20to30_000000","EGTrackIDZ_EtaPT30to40_000000" \
		--denominator "auto","auto","auto","auto" \
		--title "EGElectron (V10.7);#eta^{gen};Efficiency" --xmin -3 --xmax 3 --output $(OutputEOS)/MatchingEff_EG_Eta_PTbinned_Zboson.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

MatchingEff_TkE_Eta_PTbinned_Zboson: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "5 < pT < 10","10 < pT < 20","20 < pT < 30","30 < pT < 40" \
		--file $(OutputHists),$(OutputHists),$(OutputHists),$(OutputHists) \
		--numerator "TkElectronV2TrackIDZ_EtaPT5to10_000000","TkElectronV2TrackIDZ_EtaPT10to20_000000","TkElectronV2TrackIDZ_EtaPT20to30_000000","TkElectronV2TrackIDZ_EtaPT30to40_000000" \
		--denominator "auto","auto","auto","auto" \
		--title "TkElectronV2 (V10.7);#eta^{gen};Efficiency" --xmin -3 --xmax 3 --output $(OutputEOS)/MatchingEff_TkE_Eta_PTbinned_Zboson.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

MatchingEff_EG_Eta_PTbinned_ZbosonISO: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "5 < pT < 10","10 < pT < 20","20 < pT < 30","30 < pT < 40" \
		--file $(OutputHists),$(OutputHists),$(OutputHists),$(OutputHists) \
		--numerator "EGTrackIDIsoZ_EtaPT5to10_000000","EGTrackIDIsoZ_EtaPT10to20_000000","EGTrackIDIsoZ_EtaPT20to30_000000","EGTrackIDIsoZ_EtaPT30to40_000000" \
		--denominator "auto","auto","auto","auto" \
		--title "EGElectron (V10.7);#eta^{gen};Efficiency" --xmin -3 --xmax 3 --output $(OutputEOS)/MatchingEff_EG_Eta_PTbinned_ZbosonISO.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10

MatchingEff_TkE_Eta_PTbinned_ZbosonISO: binary/PlotComparison
	mkdir -p png
	mkdir -p $(OutputEOS)
	cp $(IndexPHP) $(OutputEOS)/index.php
	binary/PlotComparison \
		--label "5 < pT < 10","10 < pT < 20","20 < pT < 30","30 < pT < 40" \
		--file $(OutputHists),$(OutputHists),$(OutputHists),$(OutputHists) \
		--numerator "TkElectronV2TrackIDIsoZ_EtaPT5to10_000000","TkElectronV2TrackIDIsoZ_EtaPT10to20_000000","TkElectronV2TrackIDIsoZ_EtaPT20to30_000000","TkElectronV2TrackIDIsoZ_EtaPT30to40_000000" \
		--denominator "auto","auto","auto","auto" \
		--title "TkElectronV2 (V10.7);#eta^{gen};Efficiency" --xmin -3 --xmax 3 --output $(OutputEOS)/MatchingEff_TkE_Eta_PTbinned_ZbosonISO.png \
		--legendx 0.35 --legendy 0.20 \
		--rebin 10
