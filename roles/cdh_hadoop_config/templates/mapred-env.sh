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

# Newer versions of glibc use an arena memory allocator that causes virtual
# memory usage to explode. This interacts badly with the many threads that
# we use in Hadoop. Tune the variable down to prevent vmem explosion.
export MALLOC_ARENA_MAX=${MALLOC_ARENA_MAX:-4}

export JAVA_HOME="${JAVA_HOME:-/usr/java/default}"

# export HADOOP_JOB_HISTORYSERVER_HEAPSIZE="24g"

export HADOOP_MAPRED_ROOT_LOGGER=INFO,DRFA

# export HADOOP_MAPRED_LOG_DIR="/var/run/mapred/logs"

# Extra Java runtime options.  All javas get this
export HADOOP_OPTS="$HADOOP_OPTS -Djava.net.preferIPv4Stack=true"

export HADOOP_GENERIC_GCFLAGS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution"
export HADOOP_BIG_GCFLAGS="-XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:NewSize=2g -XX:MaxNewSize=2g -XX:MaxPermSize=512m -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:+CMSConcurrentMTEnabled -XX:+CMSScavengeBeforeRemark"
export HADOOP_GENERIC_JMXFLAGS="-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

export HADOOP_JOB_HISTORYSERVER_OPTS="-Xmx2g -Xloggc:${HADOOP_MAPRED_LOG_DIR}/gc-jh.log-$(date +'%Y%m%d%H%M') -Dcom.sun.management.jmxremote.port=9030 -Dcom.sun.management.jmxremote.rmi.port=9030 -Dhadoop.root.logger=INFO,DRFA -Dhadoop.security.logger=INFO,DRFAS ${HADOOP_GENERIC_GCFLAGS} ${HADOOP_GENERIC_JMXFLAGS}"
export HADOOP_JHS_LOGGER=INFO,DRFA
#export HADOOP_MAPRED_PID_DIR=/var/run/mapred/pids
#export HADOOP_MAPRED_NICENESS= #The scheduling priority for daemons. Defaults to 0.
