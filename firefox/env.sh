source $AEROOT/setup/spack/share/spack/setup-env.sh
spack load elfutils@0.179
spack load boost@1.73.0
spack load intel-tbb@2020.2

export LD_LIBRARY_PATH=$AEROOT/setup/dyninst/install/lib:$AEROOT/setup/libunwind/install/lib:$LD_LIBRARY_PATH
export LD_PRELOAD=$AEROOT/setup/dyninst/install/lib/libdyninstAPI_RT.so:$AEROOT/setup/libunwind/install/lib/libunwind.so
