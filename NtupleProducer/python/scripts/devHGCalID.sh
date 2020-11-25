#!/bin/bash

TRAINCONFIG="_5varEta"
V="110X_v1_PUWPCompFromm0p3To0p3"$TRAINCONFIG
PLOTDIR="plots/"${V}"/"
SAMPLES="--110X_v1"

W=$1; shift;
X=$1; shift;
case $W in
    ntuplePU0)
        #for X in MultiPion_PT0to200 DoublePhoton_FlatPt-1To100 DoubleElectron_FlatPt-1To100; do
            ./scripts/prun.sh runIDNTuplerHGCTune.py $SAMPLES ${X}_PU0 ${X}_PU0.${V} --inline-customize 'xdup()'
        #done;
        ;;
    ntuplePU200)
        #for X in SinglePion_PT0to200 DoublePhoton_FlatPt-1To100 DoubleElectron_FlatPt-1To100; do
            ./scripts/prun.sh runIDNTuplerHGCTune.py $SAMPLES ${X}_PU200 ${X}_PU200.${V} --inline-customize 'xdup()'
        #done;
        ;;
    trainPhVsPiPU0)
        cd $CMSSW_BASE/src/FastPUPPI/NtupleProducer/test/Training/
        python TMVATraining.py --sig DoublePhoton_FlatPt-1To100_PU0 --bkg MultiPion_PT0to200_PU0 --extraName ${V} --sigEvents 141750 --bkgEvents 9.516e+06 --sigEventsAfterCuts 115405 --bkgEventsAfterCuts 278984
        cd -
        ;;
    trainPhVsPiPU200)
        cd $CMSSW_BASE/src/FastPUPPI/NtupleProducer/test/Training/
        python TMVATraining.py --sig DoublePhoton_FlatPt-1To100_PU200 --bkg SinglePion_PT0to200_PU200 --extraName ${V} --sigEvents 22248 --bkgEvents 17938 --sigEventsAfterCuts 10332 --bkgEventsAfterCuts 2964
        cd -
        ;;
    trainPhPiVsPU200)
        cd $CMSSW_BASE/src/FastPUPPI/NtupleProducer/test/Training/
        python TMVATraining.py --sig DoublePhoton_FlatPt-1To100_PU200,SinglePion_PT0to200_PU200 --PUbkg --extraName ${V} --sigEventsAfterCuts 14938 --bkgEventsAfterCuts 150145
        cd -
        ;;
    perfGunPU0)
        #for X in MultiPion_PT0to200 DoublePhoton_FlatPt-1To100 DoubleElectron_FlatPt-1To100; do
            if [[ ${X} == "MultiPion_PT0to200" ]]; then
                ./scripts/prun.sh runPerformanceNTuple.py $SAMPLES ${X}_PU0 ${X}_PU0.${V} --inline-customize 'goGun();goSelectHGCClusters();selectGenParticles(\"pion\")';
            fi;
            if [[ ${X} == "DoublePhoton_FlatPt-1To100" ]]; then
                ./scripts/prun.sh runPerformanceNTuple.py $SAMPLES ${X}_PU0 ${X}_PU0.${V} --inline-customize 'goGun();goSelectHGCClusters();selectGenParticles(\"photon\")';
            fi;
            if [[ ${X} == "DoubleElectron_FlatPt-1To100" ]]; then
                ./scripts/prun.sh runPerformanceNTuple.py $SAMPLES ${X}_PU0 ${X}_PU0.${V} --inline-customize 'goGun();goSelectHGCClusters();selectGenParticles(\"electron\")';
            fi;
        #done;
        ;;
    perfGunPU200)
        #for X in SinglePion_PT0to200 DoublePhoton_FlatPt-1To100 DoubleElectron_FlatPt-1To100; do
            if [[ ${X} == "SinglePion_PT0to200" ]]; then
                ./scripts/prun.sh runPerformanceNTuple.py $SAMPLES ${X}_PU200 ${X}_PU200.${V} --inline-customize 'goGun();goSelectHGCClusters();selectGenParticles(\"pion\")';
            fi;
            if [[ ${X} == "DoublePhoton_FlatPt-1To100" ]]; then
                ./scripts/prun.sh runPerformanceNTuple.py $SAMPLES ${X}_PU200 ${X}_PU200.${V} --inline-customize 'goGun();goSelectHGCClusters();selectGenParticles(\"photon\")';
            fi;
            if [[ ${X} == "DoubleElectron_FlatPt-1To100" ]]; then
                ./scripts/prun.sh runPerformanceNTuple.py $SAMPLES ${X}_PU200 ${X}_PU200.${V} --inline-customize 'goGun();goSelectHGCClusters();selectGenParticles(\"electron\")';
            fi;
        #done;
        ;;
    perfPU200)
        #for X in TTbar Single_Neutrino VBF_HToInvisible; do
            ./scripts/prun.sh runPerformanceNTuple.py $SAMPLES ${X}_PU200 ${X}_PU200.${V} --inline-customize 'goRegional();goSelectHGCClusters()';
            if [[ ${X} == "TTbar" || ${X} == "VBF_HToInvisible" ]]; then
                python scripts/makeJecs.py perfNano_${X}_PU200.${V}.root -A -o ${X}_jecs.${V}.root
            fi;
        #done;
        ;;
    plotsGunPU0)
        for WHATPLOTS in debug-hgcTMVA pfdebugTMVA puppidebugTMVA; do
            X="DoublePhoton_FlatPt-1To100"; NTUPLE="perfTuple_"${X}"_PU0."${V}".root"
            echo 'Plotting directory is '$PLOTDIR/$W/${X}
            python scripts/respPlots.py $NTUPLE $PLOTDIR/$W/${X} -w $WHATPLOTS -p photon --ptmax 100.0 --ymax 2.2 --ymaxRes 1.8
            X="DoubleElectron_FlatPt-1To100"; NTUPLE="perfTuple_"${X}"_PU0."${V}".root"
            echo 'Plotting directory is '$PLOTDIR/$W/${X}
            python scripts/respPlots.py $NTUPLE $PLOTDIR/$W/${X} -w $WHATPLOTS -p electron --ptmax 100.0 --ymax 2.2 --ymaxRes 1.8
            X="MultiPion_PT0to200"; NTUPLE="perfTuple_"${X}"_PU0."${V}".root"
            echo 'Plotting directory is '$PLOTDIR/$W/${X}
            python scripts/respPlots.py $NTUPLE $PLOTDIR/$W/${X} -w $WHATPLOTS -p pion --ptmax 200.0 --ymax 2.2 --ymaxRes 1.8
        done;
        ;;
    plotsGunPU200)
        for WHATPLOTS in debug-hgcTMVA pfdebugTMVA puppidebugTMVA; do
            X="DoublePhoton_FlatPt-1To100"; NTUPLE="perfTuple_"${X}"_PU200."${V}".root"
            echo 'Plotting directory is '$PLOTDIR/$W/${X}
            python scripts/respPlots.py $NTUPLE $PLOTDIR/$W/${X} -w $WHATPLOTS -p photon --ptmax 100.0 --ymax 2.2 --ymaxRes 1.8
            X="DoubleElectron_FlatPt-1To100"; NTUPLE="perfTuple_"${X}"_PU200."${V}".root"
            echo 'Plotting directory is '$PLOTDIR/$W/${X}
            python scripts/respPlots.py $NTUPLE $PLOTDIR/$W/${X} -w $WHATPLOTS -p electron --ptmax 100.0 --ymax 2.2 --ymaxRes 1.8
            X="SinglePion_PT0to200"; NTUPLE="perfTuple_"${X}"_PU200."${V}".root"
            echo 'Plotting directory is '$PLOTDIR/$W/${X}
            python scripts/respPlots.py $NTUPLE $PLOTDIR/$W/${X} -w $WHATPLOTS -p pion --ptmax 200.0 --ymax 2.2 --ymaxRes 1.8
        done;
        ;;
    plotsPU200)
        for WHATPLOTS in debug-hgcTMVA pfdebugTMVA puppidebugTMVA; do
            X="TTbar"; NTUPLE="perfTuple_"${X}"_PU200."${V}".root"
            echo 'Plotting directory is '$PLOTDIR/$W/${X}
            python scripts/respPlots.py $NTUPLE $PLOTDIR/$W/${X} -w $WHATPLOTS -p jet --ymax 2.2 --ymaxRes 1.8
            python scripts/respPlots.py $NTUPLE $PLOTDIR/$W/${X} -w $WHATPLOTS -p electron --ymax 2.2 --ymaxRes 1.8
            X="VBF_HToInvisible"; NTUPLE="perfTuple_"${X}"_PU200."${V}".root"
            echo 'Plotting directory is '$PLOTDIR/$W/${X}
            python scripts/respPlots.py $NTUPLE $PLOTDIR/$W/${X} -w $WHATPLOTS -p jet --ymax 2.2 --ymaxRes 1.8
        done;
        ;;
    trigger)
        #for X in TTbar VBF_HToInvisible; do
        for X in TTbar; do
            NTUPLE="perfNano_"${X}"_PU200."${V}".root"
            echo 'Plotting directory is '$PLOTDIR/$W/${X}
            for WHATPLOTS in puppidebugTMVA-WPPU; do #pfdebugTMVA puppidebugTMVA; do
                for VARIABLE in ht met jet4; do
                    python scripts/jetHtSuite.py $NTUPLE perfNano_SingleNeutrino_PU200.${V}.root $PLOTDIR/$W/${X} -w ${WHATPLOTS} -v ${VARIABLE} -j ${X}_jecs.${V}.root
                done;
            done;
        done;
        ;;
    multiplicity)
        for X in TTbar VBF_HToInvisible; do
            NTUPLE="perfTuple_"${X}"_PU200."${V}".root"
            echo 'Plotting directory is '$PLOTDIR/$W/${X}
            mkdir -p $PLOTDIR/$W/${X}
            python scripts/objMultiplicityPlot.py $NTUPLE $PLOTDIR/$W/${X} --noPlots -s ${X}_PU200 -d HGCalNoTK,HGCalNoTKNoID,HGCalNoTKWithPUOldID,HGCalNoTKWithPionOldID,HGCalNoTKWithPUPionOldID,HGCalNoTKWithPUNewID,HGCalNoTKWithPionNewID,HGCalNoTKWithPUPionNewID > $PLOTDIR/$W/${X}/multiplicity.txt
        done;
        ;;
esac;
