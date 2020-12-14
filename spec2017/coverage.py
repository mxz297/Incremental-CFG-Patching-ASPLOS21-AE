import sys 
import argparse
import os
from subprocess import *
import shutil

def getParameters():
    parser = argparse.ArgumentParser(description='Count uninstrumentable functions')
    parser.add_argument("-dir", help="Path to the data set directory", required=True)
    parser.add_argument("-exe", help="Path to the executable to count uninstrumentable function", required=True)
    parser.add_argument("-dyninstrt", help="Path to the dyninst runtime library", required=True)
    args = parser.parse_args()
    return args 

def getBenchmarkExec(bench_dir):
    for root, dirs, files in os.walk(bench_dir):
        for f in files:
            if f.endswith("original"):
                return f

def Run(binary):
    cmd = "DYNINSTAPI_RT_LIB={0} OMP_NUM_THREADS=4 {1} {2}".format(args.dyninstrt, args.exe, binary)
    p = Popen(cmd, shell=True, stdout=PIPE, stderr=PIPE)
    msg, err = p.communicate()
    if (len(err) > 0): 
        print ("Error message in running", binary,":")
        print (err) 
    return msg
    
args = getParameters()

root_dir = os.path.join(args.dir, "benchspec", "CPU")

benchmarks = [ \
        "600.perlbench_s", \
        "602.gcc_s", \
        "603.bwaves_s", \
        "605.mcf_s", \
        "607.cactuBSSN_s", \
        "619.lbm_s", \
        "620.omnetpp_s", \
        "621.wrf_s", \
        "623.xalancbmk_s", \
        "625.x264_s", \
        "628.pop2_s", \
        "631.deepsjeng_s", \
        "638.imagick_s", \
        "641.leela_s", \
        "644.nab_s", \
        "648.exchange2_s", \
        "649.fotonik3d_s", \
        "654.roms_s", \
        "657.xz_s" \
        ]

avg = 1.0
minimal = 1.0
for bench in benchmarks:
    bench_dir = os.path.join(root_dir, bench, "build", "build_peak_ICFGPDIR.0000")
    bench_binary = getBenchmarkExec(bench_dir)
    msg = Run(os.path.join(bench_dir, bench_binary))
    
    # Uncomment here to print coverage for individual benchmark
    #print (bench, msg.decode().split("\n")[-2])
    val = msg.decode().split("\n")[-2].split(",")[-1].strip()[:-1]
    val = float(val) / 100
    val = 1 - val
    avg *= val
    if val < minimal:
        minimal = val
print ("Mean coverage: {0}%".format((avg ** (1.0 / len(benchmarks))) * 100.0))
print ("Min coverage: {0}%".format(minimal * 100.0))
