#!/bin/bash
cd $1
rm -rf benchspec/C*/*/run 
rm -rf benchspec/C*/*/build
rm -rf benchspec/C*/*/exe
source shrc

SPEC_OPT="--config=code-patching-x86.cfg"
SPEC_BENCH="600.perlbench_s"
SPEC_BENCH+=" 602.gcc_s"
SPEC_BENCH+=" 603.bwaves_s"
SPEC_BENCH+=" 605.mcf_s"
SPEC_BENCH+=" 607.cactuBSSN_s"
SPEC_BENCH+=" 619.lbm_s"
SPEC_BENCH+=" 620.omnetpp_s"
SPEC_BENCH+=" 621.wrf_s"
SPEC_BENCH+=" 623.xalancbmk_s"
SPEC_BENCH+=" 625.x264_s"
SPEC_BENCH+=" 628.pop2_s"
SPEC_BENCH+=" 631.deepsjeng_s"
SPEC_BENCH+=" 638.imagick_s"
SPEC_BENCH+=" 641.leela_s"
SPEC_BENCH+=" 644.nab_s"
SPEC_BENCH+=" 648.exchange2_s"
SPEC_BENCH+=" 649.fotonik3d_s"
SPEC_BENCH+=" 654.roms_s"
SPEC_BENCH+=" 657.xz_s"

runcpu $SPEC_OPT --label=ICFGPDIR --iterations $2 --tune all $SPEC_BENCH 
runcpu $SPEC_OPT --label=ICFGPJT --iterations $2 --tune peak $SPEC_BENCH 
runcpu $SPEC_OPT --label=ICFGPFUNCPTR --iterations $2 --tune peak $SPEC_BENCH 
runcpu $SPEC_OPT --label=DYNFUNCRELOC --iterations $2 --tune peak $SPEC_BENCH 
