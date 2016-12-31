#!/bin/bash

TESTDIR=st-FB2010_Proper

WORKLOAD='FB-2010_samples_24_times_1hr_0.tsv'

BLOCKSIZE=67108864 # 64MB

SCALE=$(bc -l <<< "${BLOCKSIZE}/67108864")

echo $TESTDIR
echo $WORKLOAD
echo $BLOCKSIZE
echo $SCALE

java GenerateReplayScript \
       $WORKLOAD \
       3000 \
       15 \
       $BLOCKSIZE \
       1050 \
       $TESTDIR \
       workGenInput \
       workGenOutputTest \
       $BLOCKSIZE \
       workGenLogs  \
       '$HADOOP_HOME/bin/hadoop' \
       '$SWIMDIR/workloadSuite/WorkGen.jar' \
       '$HADOOP_CONF_DIR/workGenKeyValue_conf.xsl' \
       $SCALE

cp $TESTDIR/run-jobs-all.sh $TESTDIR/expStart.sh
