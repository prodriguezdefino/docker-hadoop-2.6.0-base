## Docker base image for Apache Hadoop

A Hadoop base image container for Docker, runs on Ubuntu Trusty Tahr. 

There are some CSV files included (historical statistics from the Mayor League Baseball) that can be used for testing the installation. 

This image is heavily based on the work made in sequenceiq/docker-hadoop and amplab/docker-scripts repositories (thanks!) and there are some scripts added to launch new nodes and add them dynamically to the cluster, also, it runs on Java 8.
