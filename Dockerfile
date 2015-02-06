## Apache Hadoop Base image
#
FROM prodriguezdefino/ubuntujava
MAINTAINER prodriguezdefino prodriguezdefino@gmail.com

# install Hadoop
RUN curl -s http://www.us.apache.org/dist/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./hadoop-2.6.0 hadoop

ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop

RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/lib/jvm/java-8-oracle\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
#RUN . $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

RUN mkdir $HADOOP_PREFIX/input
RUN cp $HADOOP_PREFIX/etc/hadoop/*.xml $HADOOP_PREFIX/input

ADD core-site.xml.template $HADOOP_PREFIX/etc/hadoop/core-site.xml.template
ADD hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml

ADD mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
ADD yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml

# for test we temporarily change the installation configuration to start all in a local node 
RUN sed s/HOSTNAME/localhost/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml

RUN $HADOOP_PREFIX/bin/hdfs namenode -format

# add some test data to load later
RUN mkdir /test-data
ADD textfiles-for-test /test-data

# fixing the libhadoop.so like a boss
RUN rm  /usr/local/hadoop/lib/native/*
RUN curl -Ls http://dl.bintray.com/sequenceiq/sequenceiq-bin/hadoop-native-64-2.6.0.tar | tar -x -C /usr/local/hadoop/lib/native/

ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

# # installing supervisord
# RUN yum install -y python-setuptools
# RUN easy_install pip
# RUN curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -o - | python
# RUN pip install supervisor
#
# ADD supervisord.conf /etc/supervisord.conf

# lets add some helpfull scripts to later add and remove nodes to/from the cluster
ADD remote-remove-node.sh /etc/remote-remove-node.sh
ADD remove-node.sh /etc/remove-node.sh
ADD remote-remove-slave.sh /etc/remote-remove-slave.sh
ADD remove-slave.sh /etc/remove-slave.sh
ADD remote-add-slave.sh /etc/remote-add-slave.sh
ADD add-slave.sh /etc/add-slave.sh
ADD remote-add-node.sh /etc/remote-add-node.sh
ADD add-node.sh /etc/add-node.sh
ADD bootstrap.sh /etc/bootstrap.sh

# set the correct permissions to them
RUN chown root:root /etc/remote-remove-node.sh && chmod 700 /etc/remote-remove-node.sh && chown root:root /etc/remove-node.sh && chmod 700 /etc/remove-node.sh && chown root:root /etc/remote-remove-slave.sh && chmod 700 /etc/remote-remove-slave.sh && chown root:root /etc/remove-slave.sh && chmod 700 /etc/remove-slave.sh && chown root:root /etc/remote-add-slave.sh && chmod 700 /etc/remote-add-slave.sh && chown root:root /etc/add-slave.sh && chmod 700 /etc/add-slave.sh && chown root:root /etc/remote-add-node.sh && chmod 700 /etc/remote-add-node.sh && chown root:root /etc/add-node.sh && chmod 700 /etc/add-node.sh && chown root:root /etc/bootstrap.sh && chmod 700 /etc/bootstrap.sh

ENV BOOTSTRAP /etc/bootstrap.sh

# workingaround docker.io build error
RUN ls -la /usr/local/hadoop/etc/hadoop/*-env.sh
RUN chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh
RUN ls -la /usr/local/hadoop/etc/hadoop/*-env.sh

# fix the 254 error code
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
RUN echo "Port 2122" >> /etc/ssh/sshd_config

RUN service ssh start && $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh && $HADOOP_PREFIX/sbin/start-dfs.sh && $HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /user/root

#let everything terminate smoothly
RUN sleep 2

RUN service ssh start && $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh && $HADOOP_PREFIX/sbin/start-dfs.sh && $HADOOP_PREFIX/bin/hdfs dfs -put $HADOOP_PREFIX/etc/hadoop/ input

ENV PATH $PATH:$HADOOP_PREFIX/bin

CMD ["/etc/bootstrap.sh", "-d"]

EXPOSE 50020 50090 50070 50010 50075 8031 8032 8033 8040 8042 49707 22 8088 8030

