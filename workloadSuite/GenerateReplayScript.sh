#!/usr/bin/env sh

# java GenerateReplayScript
#      [path to synthetic workload file]
#      [number of machines in the original production cluster]
#      [number of machines in the cluster where the workload will be run]
#      [size of each input partition in bytes]
#      [number of input partitions]
#      [output directory for the scripts]
#      [HDFS directory for the input data]
#      [prefix to workload output in HDFS]
#      [amount of data per reduce task in byptes]
#      [workload stdout stderr output dir]
#      [hadoop command]
#      [path to WorkGen.jar]
#      [path to workGenKeyValue_conf.xsl]

HADOOP_HOME=/proj/ucare/ellisjoe/hadoop/hadoop-0.23.11
WORKGEN_JAR='WorkGen.jar'
WORKGEN_DIR='workGen/'

PATH_TO_SYNTH=FB-2009_samples_24_times_1hr_0_first50jobs.tsv
NUM_MACH_ORIG=600
NUM_MACH_NOW=10
#INPUT_PARTITION_SIZE=1342177280
INPUT_PARTITION_SIZE=67108864
NUM_INPUT_PARTITIONS=10
OUT_DIR=scriptsTest2
HDFS_DIR=/user/ellisjoe/workGenInput
HDFS_PRE=workGenOutputTest
DATA_PER_TASK=$INPUT_PARTITION_SIZE
WORKLOAD_OUT=workGenLogs
HADOOP_CMD=${HADOOP_HOME}/bin/hadoop
WORKGEN_PATH=$WORKGEN_JAR
CONF_PATH='/proj/ucare/ellisjoe/SWIM/workloadSuite/workGenKeyValue_conf.xsl'


javac GenerateReplayScript.java

java GenerateReplayScript   \
    $PATH_TO_SYNTH          \
    $NUM_MACH_ORIG          \
    $NUM_MACH_NOW           \
    $INPUT_PARTITION_SIZE   \
    $NUM_INPUT_PARTITIONS   \
    $OUT_DIR                \
    $HDFS_DIR               \
    $HDFS_PRE               \
    $DATA_PER_TASK          \
    $WORKLOAD_OUT           \
    $HADOOP_CMD             \
    $WORKGEN_PATH           \
    $CONF_PATH

rm -rf hdfsWrite
mkdir hdfsWrite
javac -classpath ${HADOOP_HOME}/share/hadoop/common/\*:${HADOOP_HOME}/share/hadoop/mapreduce/\*:${HADOOP_HOME}/share/hadoop/mapreduce/lib/\* -d hdfsWrite HDFSWrite.java
jar -cvf HDFSWrite.jar -C hdfsWrite/ .

rm -rf $WORKGEN_DIR
mkdir $WORKGEN_DIR
javac -classpath ${HADOOP_HOME}/share/hadoop/common/\*:${HADOOP_HOME}/share/hadoop/mapreduce/\*:${HADOOP_HOME}/share/hadoop/mapreduce/lib/\* -d $WORKGEN_DIR WorkGen.java
jar -cvf $WORKGEN_JAR -C $WORKGEN_DIR .

# remove the generated input directory in hdfs before writing to it
#printf "\n\nGenerating data...\n\n"
#${HADOOP_HOME}/bin/hadoop fs -rm -r workGenInput
#${HADOOP_HOME}/bin/hadoop jar HDFSWrite.jar org.apache.hadoop.examples.HDFSWrite -conf randomwriter_conf.xsl workGenInput

#rm -rf ${HADOOP_HOME}/scriptsTest
#cp -r scriptsTest2 ${HADOOP_HOME}/scriptsTest
cp $WORKGEN_JAR ${HADOOP_HOME}/scriptsTest
#cp run-bench.sh ${HADOOP_HOME}/scriptsTest/
#mkdir ${HADOOP_HOME}/scriptsTest/workGenLogs
