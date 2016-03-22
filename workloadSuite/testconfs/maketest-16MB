#!/bin/bash

TESTDIR=scriptsTest-16MB

#WORKLOAD='FB-2009_samples_24_times_1hr_0_first50jobs.tsv'
WORKLOAD=FB-2009_samples_24_times_1hr_0.tsv

#BLOCKSIZE=8388608 # 8MB
BLOCKSIZE=16777216 # 16MB
#BLOCKSIZE=67108864 # 64MB

echo $TESTDIR
echo $WORKLOAD
echo $BLOCKSIZE

java GenerateReplayScript \
       $WORKLOAD \
       600 \
       15 \
       $BLOCKSIZE \
       13200 \
       $TESTDIR \
       workGenInput \
       workGenOutputTest \
       $BLOCKSIZE \
       workGenLogs  \
       $HADOOP_HOME/bin/hadoop \
       /proj/ucare/riza/SWIM/workloadSuite/WorkGen.jar \
       $HADOOP_CONF_DIR/workGenKeyValue_conf.xsl
