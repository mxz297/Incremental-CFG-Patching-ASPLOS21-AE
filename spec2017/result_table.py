import sys
import csv
import os

from collections import defaultdict
from collections import namedtuple

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

result_types = [ \
        "ICFGPDIR", \
        "ICFGPJT", \
        "ICFGPFUNCPTR", \
        "DYNFUNCRELOC"
        ]

class BenchRawResult(object):
    def __init__(self, name):
        self.name = name

        self.base = 0.0
        self.peak = {}


    def __repr__(self):
        desc = ""
        desc += "Benchmark : {}\n".format(self.name)
        desc += "   base : {0:.3f}\n".format(self.base)
        desc += "   peak :"
        for k , v in self.peak.items():
            desc += " ({0}, {1:.3f}, {2:.1f})".format(k, v, (v - self.base) * 1.0 / self.base)
        desc += "\n"
        return desc

class SPECOverheadResult(object):
    def __init__(self):
        self.results = {}

    def printOneType(self, result_type):
        count = 0
        line =  "Benchmark"
        for arch in results_dirs:
            line += " & {0}".format(arch)
        line += " \\\\"
        print (line)
        print ("\\hline")
        avg = {}
        for arch in results_dirs:
            avg[arch] = 1.0

        for bench in benchmarks:            
            line = bench[: len(bench) - 2] + "\_s"            
            count += 1
            for arch in results_dirs:
                r = self.results[arch][bench]
                if result_type not in r.peak or r.peak[result_type] < 10.0:
                    line += " & NA "
                else:
                    p = (r.peak[result_type] - r.base) / r.base
                    avg[arch] = avg[arch] * (1 + p)
                    line += " & {0:.1f}\%".format(p * 100.0)                
            line += " \\\\"
            print (line)
            if count % 5 == 0:
                print ("\\hline")
        print ("\\hline")
        line = "Average"
        for arch in results_dirs:
            p = (avg[arch] ** (1.0/count)) - 1
            line += " & {0:.1f}\%".format(p * 100.0)
        line += " \\\\"
        print (line)
        print ("\\hline")

    def printOneType2(self, result_type):
        avg = 1.0
        max_overhead = -100
        count = 0
        for bench in benchmarks:
            r = self.results[bench]
            if result_type in r.peak and r.peak[result_type] > 10.0:
                p = r.peak[result_type] / r.base
                avg = avg * p
                overhead = (p - 1) * 100.0
                if overhead > max_overhead: max_overhead = overhead
                count += 1
        if count > 0:
            avg = (avg ** (1.0 / count)) - 1
            avg = avg * 100
        print ("max-overhead", max_overhead, "mean", avg, "pass", count)


    def Print(self):
        for result_type in result_types:
            print (result_type)
            self.printOneType2(result_type)
            
    def get_bar_chart_data(self, results_dir):        
        for root, dirs, files in os.walk(results_dir):
            for f in files:
                if f.endswith('.csv'):
                    self.extract_data_csv(os.path.join(root, f))
    
    def extract_data_csv(self, result_file_path):
        csv_lines = []
        in_data = False
        with open(result_file_path) as fp:
            for row in fp:
                if "Selected Results Table" in row:
                    in_data = True
                    continue
                if in_data and row.startswith("SPEC"):
                    break
                if in_data and not (row == "" or row == "\n"):
                    csv_lines.append(row)
            for row in fp:
                if row.find("--label") != -1:
                    parts = row.split()
                    index = 0
                    for index in range(len(parts)):
                        if parts[index] == "--label":
                            break
                    result_type = parts[index+1]
                    break
        self.read_data_csv(csv_lines, result_type)

    def read_data_csv(self, csv_lines, result_type):
        tmpfile = "tmp_result.csv"
        with open(tmpfile, 'w') as fp: 
            for line in csv_lines:
                fp.write(line)
        with open(tmpfile) as csvfile:
            reader = csv.DictReader(csvfile, delimiter=',')
            for row in reader:
                bench = row['Benchmark']
                if bench not in benchmarks: continue
                if bench not in self.results:
                    bench_name = bench
                    self.results[bench] = BenchRawResult(bench_name)
                res = self.results[bench]
                if row['Est. Base Run Time']:
                    res.base = float(row['Est. Base Run Time'])
                if row['Est. Peak Run Time'] == "":
                    res.peak[result_type] = 0.0
                else:
                    res.peak[result_type] = float(row['Est. Peak Run Time'])
        os.remove(tmpfile)

if __name__ == "__main__":
    results = SPECOverheadResult()
    results.get_bar_chart_data(sys.argv[1])
    results.Print()


