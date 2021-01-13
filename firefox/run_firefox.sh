export LD_LIBRARY_PATH=$AEROOT/setup/dyninst/install/lib:$AEROOT/setup/libunwind/install/lib:$LD_LIBRARY_PATH
export LD_PRELOAD=$AEROOT/setup/dyninst/install/lib/libdyninstAPI_RT.so:$AEROOT/setup/libunwind/install/lib/libunwind.so
firefox
