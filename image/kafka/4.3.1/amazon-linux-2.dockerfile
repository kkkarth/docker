# Docker image to use.
FROM sloopstash/amazon-linux-2:v1.1.1

# Install Oracle JDK.
WORKDIR /tmp
RUN set -x \
  && yum install -y wget \
  && wget -q --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/java/26/latest/jdk-26_linux-x64_bin.rpm \
  && yum install -y jdk-26_linux-x64_bin.rpm \
  && rm -f jdk-26_linux-x64_bin.rpm

# Install Kafka.
RUN set -x \
  && wget https://archive.apache.org/dist/kafka/4.3.1/kafka_2.13-4.3.1.tgz --quiet \
  && tar xvzf kafka_2.13-4.3.1.tgz > /dev/null \
  && mkdir /usr/local/lib/kafka \
  && cp -r kafka_2.13-4.3.1/* /usr/local/lib/kafka/ \
  && rm -rf kafka_2.13-4.3.1*

# Create Kafka directories.
RUN set -x \
  && mkdir /opt/kafka \
  && mkdir /opt/kafka/data \
  && mkdir /opt/kafka/log \
  && mkdir /opt/kafka/conf \
  && mkdir /opt/kafka/script \
  && mkdir /opt/kafka/system \
  && touch /opt/kafka/system/node.pid \
  && touch /opt/kafka/system/supervisor.ini \
  && ln -s /opt/kafka/system/supervisor.ini /etc/supervisord.d/kafka.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/kafka