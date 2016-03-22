#!/bin/bash

#export HADOOP_HOME="/proj/ucare/riza/hadoop-2.7.1"

javac GenerateReplayScript.java

rm -rf hdfsWrite
mkdir hdfsWrite
$JAVA_HOME/bin/javac -classpath ${HADOOP_HOME}/share/hadoop/common/\*:${HADOOP_HOME}/share/hadoop/mapreduce/\*:${HADOOP_HOME}/share/hadoop/mapreduce/lib/\* -d hdfsWrite HDFSWrite.java
$JAVA_HOME/bin/jar -cvf HDFSWrite.jar -C hdfsWrite/ .

rm -rf workGen
mkdir workGen
$JAVA_HOME/bin/javac -classpath ${HADOOP_HOME}/share/hadoop/common/\*:${HADOOP_HOME}/share/hadoop/mapreduce/\*:${HADOOP_HOME}/share/hadoop/mapreduce/lib/\* -d workGen WorkGen.java
$JAVA_HOME/bin/jar -cvf WorkGen.jar -C workGen/ .
