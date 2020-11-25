#!/bin/bash

cd ${CMSSW_BASE}/src/FastPUPPI/NtupleProducer/python
eval `scramv1 runtime -sh`

W=$1; shift;
X=$1; shift;
./scripts/devHGCalID.sh $W $X
