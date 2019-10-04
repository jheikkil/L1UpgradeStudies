default: all

all: commoncode libraries executables

CommonCode = library/L1Classes.so library/TauHelperFunctions3.o library/DrawRandom2.o library/Messenger.o
Libraries  = library/Histograms.o library/HelperFunctions.o

commoncode: $(CommonCode)	

libraries: $(Libraries)

executables: binary/FillHistograms binary/PlotComparison

library/L1Classes.so: include/L1Classes.h include/L1LinkDef.h
	mkdir -p library
	rootcint -f source/L1Classes.cpp -c include/L1Classes.h include/L1LinkDef.h
	g++ `root-config --cflags` source/L1Classes.cpp -o library/L1Classes.o -I. -c -fpic
	g++ -shared -o library/L1Classes.so library/L1Classes.o
	ln -s source/L1Classes_rdict.pcm .

library/TauHelperFunctions3.o: source/TauHelperFunctions3.cpp include/TauHelperFunctions3.h
	mkdir -p library
	g++ source/TauHelperFunctions3.cpp -Iinclude -o library/TauHelperFunctions3.o -c

library/DrawRandom2.o: source/DrawRandom2.cpp include/DrawRandom2.h
	mkdir -p library
	g++ source/DrawRandom2.cpp -Iinclude -o library/DrawRandom2.o -c

library/Messenger.o: source/Messenger.cpp include/Messenger.h
	mkdir -p library
	g++ source/Messenger.cpp -Iinclude -o library/Messenger.o -c `root-config --cflags`

library/Histograms.o: source/Histograms.cpp include/Histograms.h
	mkdir -p library
	g++ source/Histograms.cpp -Iinclude -o library/Histograms.o -c `root-config --cflags`

library/HelperFunctions.o: source/HelperFunctions.cpp include/HelperFunctions.h
	mkdir -p library
	g++ source/HelperFunctions.cpp -Iinclude -o library/HelperFunctions.o -c `fastjet-config --cxxflags` `root-config --cflags`

binary/FillHistograms: source/FillHistograms.cpp library/Histograms.o library/HelperFunctions.o
	mkdir -p binary
	g++ source/FillHistograms.cpp -Iinclude -o binary/FillHistograms $(CommonCode) \
		library/Histograms.o library/HelperFunctions.o \
		`fastjet-config --cxxflags --libs` `root-config --cflags --libs`

binary/PlotComparison: source/PlotComparison.cpp
	mkdir -p binary
	g++ source/PlotComparison.cpp -Iinclude -o binary/PlotComparison \
		`root-config --cflags --libs`

DYLL_V9p3 = /eos/cms/store/group/cmst3/group/l1tr/cepeda/triggerntuples160/RelValZEE_14/crab_ZEE_noageing_106_V9_3//190910_103305/0000//
TestRun: binary/FillHistograms binary/PlotComparison
	mkdir -p output
	mkdir -p pdf
	binary/FillHistograms --input `ls $(DYLL_V9p3)/* | head -n 10 | tr '\n' ',' | sed "s/,$$//g"` \
		--output output/DYLL_V9p3.root --StoredGen true --config config/20190823DY.config
	binary/PlotComparison \
		--label "EGElectron (V9.3)","TkElectron (V9.3)","TkIsoElectron (V9.3)" \
		--file output/DYLL_V9p3.root,output/DYLL_V9p3.root,output/DYLL_V9p3.root \
		--numerator "EGTrackIDIso_PTEta15_000000","TkElectronTrackIDIso_PTEta15_000000","TkIsoElectron_PTEta15_000000" \
		--denominator "auto","auto","TkElectronIsoNoMatch_PTEta15_000000" \
		--title ";p_{T};Efficiency" --xmin 0 --xmax 40 --output pdf/EGComparison.pdf \
		--legendx 0.45 --legendy 0.20




