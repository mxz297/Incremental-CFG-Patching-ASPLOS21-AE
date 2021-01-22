export LD_LIBRARY_PATH=$AEROOT/setup/dyninst/install/lib:$AEROOT/setup/libunwind/install/lib:$LD_LIBRARY_PATH
export LD_PRELOAD=$AEROOT/setup/dyninst/install/lib/libdyninstAPI_RT.so:$AEROOT/setup/libunwind/install/lib/libunwind.so
./docker.inst pull ubuntu:18.04
./docker.inst images
./docker.inst run --name ubuntu18 -d ubuntu:18.04 bash
./docker.inst ps
./docker.inst exec -it ubuntu18 bash
