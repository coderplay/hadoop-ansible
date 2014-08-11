# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set JAVA_HOME if it's not set
export JAVA_HOME="${JAVA_HOME:-/usr/java/default}"

# User for YARN daemons, Never set this item when using CDH versions
# export HADOOP_YARN_USER=${HADOOP_YARN_USER:-yarn}

# resolve links - $0 may be a softlink
# export YARN_CONF_DIR="${YARN_CONF_DIR:-$HADOOP_YARN_HOME/conf}"

# log dir
# export YARN_LOG_DIR="/export/apps/hadoop/logs"

# For setting YARN specific HEAP sizes please use this
# Parameter and set appropriately
YARN_HEAPSIZE=1024

# check envvars which might override default args
if [ "$YARN_HEAPSIZE" != "" ]; then
  JAVA_HEAP_MAX="-Xmx""$YARN_HEAPSIZE""m"
fi

# GC and JMX
export HADOOP_GENERIC_GCFLAGS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution"
export HADOOP_BIG_GCFLAGS="-XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:NewSize=2g -XX:MaxNewSize=2g -XX:MaxPermSize=512m -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:+CMSConcurrentMTEnabled -XX:+CMSScavengeBeforeRemark"
export HADOOP_GENERIC_JMXFLAGS="-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

# Clients
export YARN_CLIENT_OPTS="-Xmx128m $YARN_CLIENT_OPTS"

#
# Resource Manager
#
YARN_RESOURCEMANAGER_OPTS="-Xmx8g -Xms4g -Dyarn.server.resourcemanager.appsummary.log.file=rm-appsummary.log -Dyarn.server.resourcemanager.appsummary.logger=INFO,RMSUMMARY -Dcom.sun.management.jmxremote.port=9013 -Dcom.sun.management.jmxremote.rmi.port=9013 -Xloggc:${YARN_LOG_DIR}/gc-rm.log-$(date +'%Y%m%d%H%M') -Dhadoop.root.logger=INFO,DRFA -Dyarn.root.logger=INFO,DRFA ${HADOOP_GENERIC_GCFLAGS} ${HADOOP_BIG_GCFLAGS} ${HADOOP_GENERIC_JMXFLAGS}"


#
# Node Manager

YARN_NODEMANAGER_OPTS="-Xmx1g -Xms512m -Dcom.sun.management.jmxremote.port=9014 -Dcom.sun.management.jmxremote.rmi.port=9014 -Xloggc:${YARN_LOG_DIR}/gc-nm.log-$(date +'%Y%m%d%H%M') -Dyarn.root.logger=INFO,DRFA -Dhadoop.root.logger=INFO,DRFA ${HADOOP_GENERIC_GCFLAGS} ${HADOOP_GENERIC_JMXFLAGS}"

# default log directory & file
if [ "$YARN_LOG_DIR" = "" ]; then
  YARN_LOG_DIR="$HADOOP_YARN_HOME/logs"
fi
if [ "$YARN_LOGFILE" = "" ]; then
  YARN_LOGFILE='yarn.log'
fi

# Pid DIR
# export YARN_PID_DIR=/var/run/yarn/pids

# default policy file for service-level authorization
if [ "$YARN_POLICYFILE" = "" ]; then
  YARN_POLICYFILE="hadoop-policy.xml"
fi

YARN_OPTS="$YARN_OPTS -Dhadoop.log.dir=$YARN_LOG_DIR"
YARN_OPTS="$YARN_OPTS -Dyarn.log.dir=$YARN_LOG_DIR"
YARN_OPTS="$YARN_OPTS -Dhadoop.log.file=$YARN_LOGFILE"
YARN_OPTS="$YARN_OPTS -Dyarn.log.file=$YARN_LOGFILE"
YARN_OPTS="$YARN_OPTS -Dyarn.home.dir=$YARN_COMMON_HOME"
YARN_OPTS="$YARN_OPTS -Dyarn.id.str=$YARN_IDENT_STRING"
YARN_OPTS="$YARN_OPTS -Dhadoop.root.logger=${YARN_ROOT_LOGGER:-INFO,console}"
YARN_OPTS="$YARN_OPTS -Dyarn.root.logger=${YARN_ROOT_LOGGER:-INFO,console}"
YARN_OPTS="$YARN_OPTS -Dyarn.policy.file=$YARN_POLICYFILE"
YARN_OPTS="$YARN_OPTS -Djava.net.preferIPv4Stack=true"
if [ "x$JAVA_LIBRARY_PATH" != "x" ]; then
  YARN_OPTS="$YARN_OPTS -Djava.library.path=$JAVA_LIBRARY_PATH"
fi
export YARN_OPTS
