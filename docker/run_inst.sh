source $AEROOT/setup/spack/share/spack/setup-env.sh
spack load elfutils@0.179
spack load boost@1.73.0
spack load intel-tbb@2020.2

export DYNINSTAPI_RT_LIB=$AEROOT/setup/dyninst/install/lib/libdyninstAPI_RT.so

OMP_NUM_THREADS=8 $AEROOT/setup/BlockTrampoline --disable-function-pointer-reloc --output docker.inst $1
