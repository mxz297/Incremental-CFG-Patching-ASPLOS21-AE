#!/bin/bash

# Build software dependencies through spack
git clone https://github.com/spack/spack.git
git clone -b asplos21 https://github.com/mxz297/capstone.git capstone
git clone -b asplos21 https://github.com/mxz297/libunwind.git libunwind
git clone -b asplos21 https://github.com/mxz297/dyninst.git dyninst

source spack/share/spack/setup-env.sh
spack install gcc@7.3.0
spack load gcc@7.3.0
spack compiler find
spack install dyninst@10.2.1 ^cmake@3.14.4 ^elfutils@0.179 ^boost@1.73.0 ^intel-tbb@2020.2 %gcc@7.3.0

# Load dependencies
spack load cmake@3.14.4
spack load elfutils@0.179
spack load boost@1.73.0
spack load intel-tbb@2020.2

# Build our code and customized dependencies
cd capstone
mkdir -p install build
cd build
cmake -DCMAKE_INSTALL_PREFIX=`pwd`/../install ..
make install -j4
cd ../..

cd libunwind
mkdir install
./autogen.sh
./configure --prefix=`pwd`/install --enable-cxx-exceptions
make install -j4
cd ..

cd dyninst
mkdir -p install build
cd build
cmake -DLibunwind_ROOT_DIR=`pwd`/../../libunwind/install -DCapstone_ROOT_DIR=`pwd`/../../capstone/install/ -DCMAKE_INSTALL_PREFIX=`pwd`/../install -G 'Unix Makefiles' ..
make install -j4
cd ../..

# Compile the instrumentation tool
make DYNINST_ROOT=`pwd`/dyninst/install DYNINST_RELEASE=`spack location -i dyninst@10.2.1`

# Print paths for SPEC config file
rm -f spec-config-paths.txt
echo "%define gcc_dir" "`spack location -i gcc@7.3.0`" >> spec-config-paths.txt
echo "%define boost_lib" "`spack location -i boost@1.73.0`/lib" >> spec-config-paths.txt
echo "%define elfutils_lib" "`spack location -i elfutils@0.179`/lib" >> spec-config-paths.txt
echo "%define tbb_lib" "`spack location -i intel-tbb@2020.2`/lib" >> spec-config-paths.txt
echo "%define libunwind_lib" "`pwd`/libunwind/install/lib" >> spec-config-paths.txt
echo "%define dyninst_lib" "`pwd`/dyninst/install/lib" >> spec-config-paths.txt
echo "%define dyninst_mutator" "`pwd`/BlockTrampoline" >> spec-config-paths.txt
echo "%define dyninst_release_lib" "`spack location -i dyninst@10.2.1`/lib" >> spec-config-paths.txt
echo "%define dyninst_release_mutator" "`pwd`/FuncReloc" >> spec-config-paths.txt



