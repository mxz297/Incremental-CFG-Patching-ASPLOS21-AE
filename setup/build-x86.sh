#!/bin/bash

# Build software dependencies through spack
git clone https://github.com/spack/spack.git
source spack/share/spack/setup-env.sh
spack install gcc@7.3.0
spack compiler find
spack install dyninst@10.2.1 ^cmake@3.14.4 ^elfutils@0.179 ^boost@1.73.0 ^intel-tbb@2020.2 %gcc@7.3.0

# Load dependencies
spack load gcc@7.3.0
spack load cmake@3.14.4
spack load elfutils@0.179
spack load boost@1.73.0
spack load intel-tbb@2020.2

# Build our code and customized dependencies
git clone -b asplos21 https://github.com/mxz297/capstone.git capstone
cd capstone
mkdir -p install build
cd build
cmake -DCMAKE_INSTALL_PREFIX=`pwd`/../install ..
make install -j4
cd ../..

git clone -b asplos21 https://github.com/mxz297/libunwind.git libunwind
cd libunwind
mkdir install
./autogen.sh
./configure --prefix=`pwd`/install --enable-cxx-exceptions
make install -j4
cd ..

git clone -b asplos21 https://github.com/mxz297/dyninst.git dyninst
cd dyninst
mkdir -p install build
cd build
cmake -DLibunwind_ROOT_DIR=`pwd`/../../libunwind/install -DCapstone_ROOT_DIR=`pwd`/../../capstone/install/ -DCMAKE_INSTALL_PREFIX=`pwd`/../install -G 'Unix Makefiles' ..
make install -j4
cd ../..

# Compile the instrumentation tool
make 

# Print compiler's location
spack location -i gcc@7.3.0 > compiler-location.txt
