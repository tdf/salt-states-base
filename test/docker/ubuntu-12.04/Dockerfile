from stackbrew/ubuntu:precise

RUN apt-get update
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe multiverse restricted" > /etc/apt/sources.list && \
  apt-get update && apt-get upgrade -y -o DPkg::Options::=--force-confold

# Add the Salt PPA
RUN apt-get install -y -o DPkg::Options::=--force-confold apt-utils python-software-properties software-properties-common && \
  apt-add-repository -y ppa:saltstack/salt && apt-get update

# Install Salt Dependencies
RUN apt-get install -y -o DPkg::Options::=--force-confold python
RUN apt-get install -y -o DPkg::Options::=--force-confold salt-minion