#!/bin/bash
# install_hadoop.sh - Robust Hadoop Installer for Ubuntu (Noble 24.04 support)

set -e

# Detect the real user (important when using sudo)
REAL_USER=${SUDO_USER:-$USER}
REAL_HOME=$(eval echo ~$REAL_USER)

echo "🚀 Starting Hadoop Installation for: $REAL_USER"
echo "📂 Target Directory: $REAL_HOME"

# 1. Install system dependencies
echo "📦 Installing system packages (Requires sudo)..."
sudo apt-get update
sudo apt-get install -y openjdk-11-jdk ssh pdsh wget tar bash python3

# 2. Setup SSH for passwordless localhost access
echo "🔑 Configuring SSH..."
sudo -u $REAL_USER mkdir -p "$REAL_HOME/.ssh"
if [ ! -f "$REAL_HOME/.ssh/id_rsa" ]; then
    sudo -u $REAL_USER ssh-keygen -t rsa -P "" -f "$REAL_HOME/.ssh/id_rsa"
    sudo -u $REAL_USER sh -c "cat $REAL_HOME/.ssh/id_rsa.pub >> $REAL_HOME/.ssh/authorized_keys"
    sudo -u $REAL_USER chmod 0600 "$REAL_HOME/.ssh/authorized_keys"
fi
# Auto-accept localhost keys
sudo -u $REAL_USER sh -c "printf 'Host localhost\n  StrictHostKeyChecking no\nHost 0.0.0.0\n  StrictHostKeyChecking no\n' > $REAL_HOME/.ssh/config"

# 3. Download Hadoop 3.3.6 (using stable Archive link)
HADOOP_VERSION="3.3.6"
HADOOP_FILE="hadoop-$HADOOP_VERSION.tar.gz"
HADOOP_URL="https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/$HADOOP_FILE"
HADOOP_DIR="$REAL_HOME/hadoop-$HADOOP_VERSION"

if [ ! -d "$HADOOP_DIR" ]; then
    echo "⬇️ Downloading Hadoop $HADOOP_VERSION... (This may take a few minutes)"
    cd /tmp
    rm -f "$HADOOP_FILE"
    # Use -c to resume if interrupted, and --show-progress
    wget --no-check-certificate "$HADOOP_URL"
    
    echo "📦 Extracting Hadoop to $REAL_HOME..."
    sudo -u $REAL_USER tar -xzf "$HADOOP_FILE" -C "$REAL_HOME"
    rm "$HADOOP_FILE"
fi

# 4. Environment Configuration
BASHRC="$REAL_HOME/.bashrc"
echo "⚙️ Configuring Environment..."

# Correct Java Path for Ubuntu 24.04/Noble
JAVA_VAL="/usr/lib/jvm/java-11-openjdk-amd64"

if ! grep -q "HADOOP_HOME" "$BASHRC"; then
    cat << EOF | sudo -u $REAL_USER tee -a "$BASHRC"

# Hadoop Environment Variables
export JAVA_HOME="$JAVA_VAL"
export HADOOP_HOME="$HADOOP_DIR"
export HADOOP_INSTALL="\$HADOOP_HOME"
export HADOOP_MAPRED_HOME="\$HADOOP_HOME"
export HADOOP_COMMON_HOME="\$HADOOP_HOME"
export HADOOP_HDFS_HOME="\$HADOOP_HOME"
export YARN_HOME="\$HADOOP_HOME"
export HADOOP_COMMON_LIB_NATIVE_DIR="\$HADOOP_HOME/lib/native"
export PATH="\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin"
export PDSH_RCMD_TYPE=ssh
EOF
fi

# Create individual helper file
cat << EOF | sudo -u $REAL_USER tee "$REAL_HOME/hadoop_env.sh"
export JAVA_HOME="$JAVA_VAL"
export HADOOP_HOME="$HADOOP_DIR"
export PATH="\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin"
export PDSH_RCMD_TYPE=ssh
EOF

# 5. Configure Hadoop XMLs
echo "📝 Writing Hadoop XML configs..."
sudo -u $REAL_USER mkdir -p "$REAL_HOME/hadoopdata/hdfs/namenode"
sudo -u $REAL_USER mkdir -p "$REAL_HOME/hadoopdata/hdfs/datanode"

# core-site.xml
cat << EOF | sudo -u $REAL_USER tee "$HADOOP_DIR/etc/hadoop/core-site.xml"
<configuration>
    <property><name>fs.defaultFS</name><value>hdfs://localhost:9000</value></property>
</configuration>
EOF

# hdfs-site.xml
cat << EOF | sudo -u $REAL_USER tee "$HADOOP_DIR/etc/hadoop/hdfs-site.xml"
<configuration>
    <property><name>dfs.replication</name><value>1</value></property>
    <property><name>dfs.namenode.name.dir</name><value>file://$REAL_HOME/hadoopdata/hdfs/namenode</value></property>
    <property><name>dfs.datanode.data.dir</name><value>file://$REAL_HOME/hadoopdata/hdfs/datanode</value></property>
</configuration>
EOF

# hadoop-env.sh
sudo -u $REAL_USER sh -c "echo 'export JAVA_HOME=$JAVA_VAL' >> $HADOOP_DIR/etc/hadoop/hadoop-env.sh"

# 6. Format NameNode
echo "🧹 Formatting HDFS NameNode..."
sudo -u $REAL_USER "$HADOOP_DIR/bin/hdfs" namenode -format -nonInteractive -force

echo "✅ SUCCESS! Hadoop is installed for user $REAL_USER."
echo "➡️  Step 1: run: . ~/hadoop_env.sh"
echo "➡️  Step 2: run: start-dfs.sh"
