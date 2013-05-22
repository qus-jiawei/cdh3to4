# Set Hadoop-specific environment variables here.

# The only required environment variable is JAVA_HOME.  All others are
# optional.  When running a distributed configuration it is best to
# set JAVA_HOME in this file, so that it is correctly defined on
# remote nodes.

# The java implementation to use.  Required.
JAVA_HOME=$HOME/java/jdk
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/pkg/lzo/lib
#export JAVA_LIBRARY_PATH=$JAVA_LIBRARY_PATH:$HOME/pkg/lzo/lib
# Extra Java CLASSPATH elements.  Optional.
# export HADOOP_CLASSPATH="<extra_entries>:$HADOOP_CLASSPATH"

# The maximum amount of heap to use, in MB. Default is 1000.
# export HADOOP_HEAPSIZE=5000

# Extra Java runtime options.  Empty by default.
# if [ "$HADOOP_OPTS" == "" ]; then export HADOOP_OPTS=-server; else HADOOP_OPTS+=" -server"; fi

UC_HADOOP_MEM_NN="-Xss128k -Xmn256m -Xms5102m -Xmx5102m"
UC_HADOOP_MEM_JT="-Xss128k -Xmn256m -Xms3072m -Xmx3072m"
UC_HADOOP_MEM_DN="-Xss128k -Xmn256m -Xms1024m -Xmx1024m"
UC_HADOOP_MEM_TT="-Xss128k -Xmn256m -Xms1024m -Xmx1024m"

UC_HADOOP_SERVER="-server"
UC_HADOOP_SERVER="$UC_HADOOP_SERVER -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:+CMSClassUnloadingEnabled"
UC_HADOOP_SERVER="$UC_HADOOP_SERVER -Dclient.encoding.override=UTF-8 -Dfile.encoding=UTF-8 -Duser.language=zh -Duser.region=CN"

# Command specific options appended to HADOOP_OPTS when specified
export HADOOP_NAMENODE_OPTS="$UC_HADOOP_SERVER $UC_HADOOP_MEM_NN -Dcom.sun.management.jmxremote $HADOOP_NAMENODE_OPTS"
export HADOOP_SECONDARYNAMENODE_OPTS="$UC_HADOOP_SERVER $UC_HADOOP_MEM_NN -Dcom.sun.management.jmxremote $HADOOP_SECONDARYNAMENODE_OPTS"
export HADOOP_DATANODE_OPTS="$UC_HADOOP_SERVER $UC_HADOOP_MEM_DN -Dcom.sun.management.jmxremote $HADOOP_DATANODE_OPTS"
export HADOOP_BALANCER_OPTS="-Dcom.sun.management.jmxremote $HADOOP_BALANCER_OPTS"
export HADOOP_JOBTRACKER_OPTS="$UC_HADOOP_SERVER $UC_HADOOP_MEM_JT -Dcom.sun.management.jmxremote $HADOOP_JOBTRACKER_OPTS"
export HADOOP_TASKTRACKER_OPTS="$UC_HADOOP_SERVER $UC_HADOOP_MEM_TT -Dcom.sun.management.jmxremote"

# The following applies to multiple commands (fs, dfs, fsck, distcp etc)
# export HADOOP_CLIENT_OPTS

# Extra ssh options.  Empty by default.
# export HADOOP_SSH_OPTS="-o ConnectTimeout=1 -o SendEnv=HADOOP_CONF_DIR"

# Where log files are stored.  $HADOOP_HOME/logs by default.
# export HADOOP_LOG_DIR=${HADOOP_HOME}/logs

# File naming remote slave hosts.  $HADOOP_HOME/conf/slaves by default.
# export HADOOP_SLAVES=${HADOOP_HOME}/conf/slaves

# host:path where hadoop code should be rsync'd from.  Unset by default.
# export HADOOP_MASTER=master:/home/$USER/src/hadoop

# Seconds to sleep between slave commands.  Unset by default.  This
# can be useful in large clusters, where, e.g., slave rsyncs can
# otherwise arrive faster than the master can service them.
# export HADOOP_SLAVE_SLEEP=0.1

# The directory where pid files are stored. /tmp by default.
# export HADOOP_PID_DIR=/var/hadoop/pids

# A string representing this instance of hadoop. $USER by default.
# export HADOOP_IDENT_STRING=$USER

# The scheduling priority for daemon processes.  See 'man nice'.
# export HADOOP_NICENESS=10
