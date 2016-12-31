#!/usr/bin/env python

import sys
import re
from collections import defaultdict
import pprint

ORI_SIZE = 1000
CLUSTER_SIZE = 15
SCALE = 1.0 * CLUSTER_SIZE / ORI_SIZE
MAX_DURATION = 600

def scaleByte(byte):
    scaledByte = max((SCALE * byte), (1024**2 * 64))
    return int(scaledByte)

jobs = sys.argv[1]
j = open(jobs, 'r')
ij_times = {}
map_bytes = {}
scaled_bytes = {}

bytes = 0
best_bytes = 0
sum = 0
best_sum = 0
sbytes = 0
best_sbytes = 0
smalljobs = 0
fewest_smalljobs = 0

index_start = 0
index_end = 149

for line in j:
    fields = re.split(r'\t+', line)
    ij_times[fields[0]] = fields[2]
    map_bytes[fields[0]] = int(fields[3])
    scaled_bytes[fields[0]] = scaleByte(int(fields[3]))

if len(ij_times) < 150:
    sys.exit("Not enough jobs!")

for i in range(0, 150):
    best_sum = best_sum + int(ij_times['job' + str(i)])
    sum = best_sum
    best_bytes = best_bytes + map_bytes['job' + str(i)]
    bytes = best_bytes
    best_sbytes = best_sbytes + scaled_bytes['job' + str(i)]
    sbytes = best_sbytes
    fewest_smalljobs += 1 if (scaled_bytes['job' + str(i)] / (1024**2 * 64)) <= 1 else 0
    smalljobs = fewest_smalljobs

    
for i in range(150, len(ij_times)):

    new_sum = sum - int(ij_times['job' + str(i-150)]) + int(ij_times['job' + str(i)])
    new_bytes = bytes - map_bytes['job' + str(i-150)] + map_bytes['job' + str(i)]
    new_sbytes = sbytes - scaled_bytes['job' + str(i-150)] + scaled_bytes['job' + str(i)]
    new_smalljobs = smalljobs - (1 if (scaled_bytes['job' + str(i-150)] / (1024**2 * 64)) <= 1 else 0) \
                              + (1 if (scaled_bytes['job' + str(i)] / (1024**2 * 64)) <= 1 else 0)

    if new_sum <= MAX_DURATION:
#        if new_sbytes > best_sbytes:
        if (new_smalljobs < fewest_smalljobs) or \
           (new_smalljobs == fewest_smalljobs and new_sbytes > best_sbytes):
            best_sum = new_sum
            best_bytes = new_bytes
            best_sbytes = new_sbytes
            fewest_smalljobs = new_smalljobs
            index_start = int(str(i-150+1))
            index_end = int(str(i))

    sum = new_sum
    bytes = new_bytes
    sbytes = new_sbytes
    smalljobs = new_smalljobs

    # if new_sum < best_sum:
        # best_sum = new_sum
        # index_start = int(str(i-150+1))
        # index_end = int(str(i))

#scaled_bytes = str(int(round((best_bytes * 0.015) / 1000000)))
#if scaled_bytes < 64000000:
#    scaled_bytes = 64000000

if (best_sum > MAX_DURATION):
    print "NO SUCH JOB PERIOD"
else:
    print "Interarrival sum (seconds): " + str(best_sum)
    print "Bytes: " + str(best_bytes)
    print "Bytes (scaled, x "+str(SCALE)+"): " + str(best_sbytes)
    print "Smalljobs: " + str(fewest_smalljobs)
    print "Start index: " + str(index_start)
    print "End index: " + str(index_end)

    print "Scaled map size distributions:"
    block_ct = {}
    for i in range(index_start, index_end):
        numblock = scaled_bytes["job"+str(i)] / (1024**2 * 64)
#        print numblock
        if numblock in block_ct:
            block_ct[numblock] += 1
        else:
            block_ct[numblock] = 1

    pp = pprint.PrettyPrinter(indent=2)
    pp.pprint(block_ct)
