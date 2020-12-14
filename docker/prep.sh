SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)

#weijie: change the name of ShadowGuard

Default_SG_PATH=$(cd "$(dirname "$0")";cd ..;pwd)/ShadowGuard

echo "Current shell directory: $SHELL_FOLDER"
echo "Default SG_PATH: $Default_SG_PATH"
SG_PATH=$Default_SG_PATH

echo "Please enter the absolute path of ShadowGuard..."
read input_path

if  [ ! -n "$input_path" ] ;then
	SG_PATH=$Default_SG_PATH
else
	SG_PATH=$input_path
fi
echo "Setting $SG_PATH/thirdparty as Dyninst root path..."

export LD_PRELOAD=$SG_PATH/ShadowGuard/thirdparty/dyninst-10.1.0/install/lib/libdyninstAPI_RT.so:$SG_PATH/ShadowGuard/thirdparty/libunwind/install/lib/libunwind.so
export LD_LIBRARY_PATH=.:$SG_PATH/ShadowGuard/thirdparty/dyninst-10.1.0/install/lib:$SG_PATH/ShadowGuard/thirdparty/libunwind/install/lib:$LD_LIBRARY_PATH
export DYNINSTAPI_RT_LIB=$SG_PATH/ShadowGuard/thirdparty/dyninst-10.1.0/install/lib/libdyninstAPI_RT.so

# prepare the Makefile
DYNINST_ROOT_TEXT=$SG_PATH/thirdparty/dyninst-10.1.0/install
echo "DYNINST_ROOT = "$DYNINST_ROOT_TEXT >> Makefile_header
cat Makefile_header Makefile_template > Makefile
rm -f Makefile_header
