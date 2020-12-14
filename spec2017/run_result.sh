#!/bin/bash
echo "Instrumentation overhead and pass results"
python result_table.py $1

source $AEROOT/setup/spack/share/spack/setup-env.sh
spack load elfutils@0.179
spack load boost@1.73.0
spack load intel-tbb@2020.2

echo "Instrumentation coverage for our approach"
python coverage.py -exe $AEROOT/setup/Uninst -dir $1 -dyninstrt $AEROOT/setup/dyninst/install/lib/libdyninstAPI_RT.so

echo "Instrumentation coverage for Dyninst-10.2"
python coverage.py -exe $AEROOT/setup/Uninst-10.2.1 -dir $1 -dyninstrt `spack location -i dyninst@10.2.1`/lib/libdyninstAPI_RT.so
