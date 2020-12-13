# Introduction
This repository contains the software artifact needed for paper "Incremental CFG Patching for Binary Rewriting".

We use x86 as the example.

# Setup software

```
git clone https://github.com/mxz297/Incremental-CFG-Patching-ASPLOS21-AE.git
cd Incremental-CFG-Patching-ASPLOS21-AE/
export AEROOT=`pwd`
cd setup
./build-x86.sh
```

There should be a file named `spec-config-paths.txt`, which contains necessary paths needed for running SPEC CPU 2017.

# SPEC 2017 

Suppose the SPEC CPU 2017 benchmark is available in `$AEROOT/spec2017/spec_cpu2017`. We expect a `shrc` file in the directory, for which we can `source` to setup necessary environments for running SPEC CPU 2017.

First, after `source shrc`, test if you have all necessary library dependencies available on your system

```
runcpu
```

There should be no error.

Second, copy the provided config file to the proper directory and edit the config file:

```
cp $AEROOT/spec2017/x86/code-patching-x86.cfg $AEROOT/spec2017/spec_cpu2017/config
vim $AEROOT/spec2017/spec_cpu2017/config
```

The most important editing here is to fill in the paths needed for running experiments. Search for `ASPLOS21AEEDIT` and there should be two matches. One of them is to change the number of concurrent threads for running the experiments and it should look like:

```
# ASPLOS21AEEDIT: number of OpenMP threads
intspeed,fpspeed:
   threads          = 8   # EDIT to change number of OpenMP threads (see above)
```

The other match is to setup the paths and it should look like:

```
#------- Compilers ------------------------------------------------------------
default:

# ASPLOS21AEEDIT: Copy and paste genearted path

%define gcc_dir /projects/spack/opt/spack/linux-rhel7-x86_64/gcc-4.8.5/gcc-7.3.0-qrjpi76aeo4bysagruwwfii6oneh56lj
%define boost_lib /home/xm13/spack/opt/spack/linux-rhel7-power9le/gcc-6.4.0/boost-1.73.0-2uqm5ox4miwer5tqwuutcss4wbsxhltd/lib
%define elfutils_lib /home/xm13/spack/opt/spack/linux-rhel7-power9le/gcc-6.4.0/elfutils-0.179-duvfsqtjwguwyo77czviqtitmqlozmoa/lib
%define tbb_lib /home/xm13/spack/opt/spack/linux-rhel7-power9le/gcc-6.4.0/intel-tbb-2020.2-tpdywwttxoj4dbsinjdbxlffbtovf3nd/lib
%define libunwind_lib /home/xm13/spack/opt/spack/linux-rhel7-power9le/gcc-6.4.0/libunwind-1.4.0-q6cg7tx62x62cjpe4lzw3ljlqlodcbdo/lib64
%define dyninst_lib /home/xm13/dyninstapi/install/lib
%define dyninst_mutator /home/xm13/projects/code-patching-work-repo/BlockTrampoline/BlockTrampoline
%define dyninst_release_lib /home/xm13/dyninst-master/install/lib
%define dyninst_release_mutator /home/xm13/dyninst-master/FuncReloc
```

Now open file `$AEROOT/setup/spec-config-paths.txt`. You should be able to just copy and paste paths from `spec-config-paths.txt` to the SPEC config file.

We should be ready to run the experiments:

```
cd $AEROOT/spec2017/x86
./run_spec.sh $AEROOT/spec2017/spec_cpu2017 10
```

The `run_spec.sh` script takes two input the parameters. The first one is the root directory path to the SPEC CPU 2017 benchmark. The second one is the number of iterations to run each benchmark. The results reported in our paper are based on 10 iterations, which can take a week to finish. You can reduce the number of iterations or increase the number of concurrent threads for running the benchmarks.

# Firefox's libxul.so

# Docker executable 

# Diogenes
