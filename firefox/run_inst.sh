source $AEROOT/setup/spack/share/spack/setup-env.sh
spack load elfutils@0.179
spack load boost@1.73.0
spack load intel-tbb@2020.2

export DYNINSTAPI_RT_LIB=$AEROOT/setup/dyninst/install/lib/libdyninstAPI_RT.so

# Use hpcfnbound from HPCToolkit to parse .eh_frame
export DYNINST_PARSE_USE_HPCFNBOUND=`spack location -i hpctoolkit`/libexec/hpctoolkit/hpcfnbounds2

#OMP_NUM_THREADS=8 $AEROOT/setup/BlockTrampoline --output libxul.so.funcptr $1
OMP_NUM_THREADS=8 $AEROOT/setup/BlockTrampoline --disable-function-pointer-reloc --output libxul.so.jt $1
