# Copyright 2011 The Apache Software Foundation
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# {{ ansible_managed }}

# Set Hadoop-specific environment variables here.

# The only required environment variable is JAVA_HOME.  All others are
# optional.  When running a distributed configuration it is best to
# set JAVA_HOME in this file, so that it is correctly defined on
# remote nodes.

# Set JAVA_HOME if it's not set
export JAVA_HOME="${JAVA_HOME:-/usr/java/default}"

# export JSVC_HOME=/export/apps/hadoop/site/jsvc
# export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/etc/hadoop/conf"}
# export HADOOP_SITE_DIR=/export/apps/hadoop/site

#
# Logging
#
# export HADOOP_LOG_DIR=/var/log/hadoop

#
# Class Path
#   Automatically insert capacity-scheduler. Will also get site libs (grid topology)
#
# for f in $HADOOP_HOME/contrib/capacity-scheduler/*.jar $HADOOP_SITE_DIR/lib/*.jar; do
#   if [ "$HADOOP_CLASSPATH" ]; then
#     export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$f
#   else
#     export HADOOP_CLASSPATH=$f
#   fi
# done

#
# Native Libraries
#   Add site native libraries to JAVA/LD Path
#
if [ "x$JAVA_LIBRARY_PATH" == "x" ]; then
  export JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native:$HADOOP_SITE_DIR/lib/native
else
  export JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native:$HADOOP_SITE_DIR/lib/native:$JAVA_LIBRARY_PATH
fi

# The maximum amount of heap to use, in MB. Default is 1000.
export HADOOP_HEAPSIZE=1024

# Extra Java runtime options.  All javas get this
export HADOOP_OPTS="$HADOOP_OPTS -Xbootclasspath/p:/usr/lib/jvm/floatingdecimal-0.1.jar -Djava.net.preferIPv4Stack=true"

# GC and JMX
export HADOOP_GENERIC_GCFLAGS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution"
export HADOOP_BIG_GCFLAGS="-XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:NewSize=2g -XX:MaxNewSize=2g -XX:MaxPermSize=512m -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:+CMSConcurrentMTEnabled -XX:+CMSScavengeBeforeRemark"
export HADOOP_GENERIC_JMXFLAGS="-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

#
# Client
#
export HADOOP_CLIENT_OPTS="-Xmx128m $HADOOP_CLIENT_OPTS"

#
# JournalNode
#
export HADOOP_JOURNALNODE_OPTS="-Xmx1g -Xms512m -XX:+UseParallelGC -Xloggc:${HADOOP_LOG_DIR}/gc-jn.log-$(date +'%Y%m%d%H%M') -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.rmi.port=9010 -Dhadoop.root.logger=INFO,DRFA -Dhadoop.security.logger=INFO,DRFAS ${HADOOP_GENERIC_GCFLAGS} ${HADOOP_GENERIC_JMXFLAGS}"

#
# Namenode
#
export HADOOP_NAMENODE_OPTS="-Xmx8g -Xms4g -Xloggc:${HADOOP_LOG_DIR}/gc-nn.log-$(date +'%Y%m%d%H%M') -Dcom.sun.management.jmxremote.port=9011 -Dcom.sun.management.jmxremote.rmi.port=9011 -Dhadoop.root.logger=INFO,DRFA -Dhadoop.security.logger=INFO,DRFAS -Dhdfs.audit.logger=INFO,RFAAUDIT ${HADOOP_GENERIC_GCFLAGS} ${HADOOP_BIG_GCFLAGS} ${HADOOP_GENERIC_JMXFLAGS}"

#
# Datanode
#
export HADOOP_DATANODE_OPTS="-Xmx1g -Xloggc:${HADOOP_LOG_DIR}/gc-dn.log-$(date +'%Y%m%d%H%M') -Dcom.sun.management.jmxremote.port=9012 -Dcom.sun.management.jmxremote.rmi.port=9012 -Dhadoop.root.logger=INFO,DRFA -Dhadoop.security.logger=INFO,DRFAS ${HADOOP_GENERIC_GCFLAGS} ${HADOOP_GENERIC_JMXFLAGS}"

# On secure datanodes, user to run the datanode as after dropping privileges
# export HADOOP_SECURE_DN_USER=hdfs

# Where log files are stored in the secure data environment.
# export HADOOP_SECURE_DN_LOG_DIR=${HADOOP_LOG_DIR}/${HADOOP_HDFS_USER}

# The directory where pid files are stored. /tmp by default.
# NOTE: this should be set to a directory that can only be written to by
#       the user that will run the hadoop daemons.  Otherwise there is the
#       potential for a symlink attack.
# export HADOOP_PID_DIR=/var/run/hadoop/pids
# export HADOOP_SECURE_DN_PID_DIR=${HADOOP_PID_DIR}

# A string representing this instance of hadoop. $USER by default.
# IMPORTANT: NEVER SET THIS ITEM WHEN USING CDH VERSIONS!
# export HADOOP_IDENT_STRING=$USER

# for slaves.sh
# export HADOOP_SSH_OPTS="-o IdentityFile=~/.ssh/id_rsa -o IdentityFile=~/.ssh/id_dsa -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10s"
