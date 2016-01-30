from stackbrew/debian:jessie

# Keep upstart from complaining
# RUN dpkg-divert --local --rename --add /sbin/initctl
# RUN ln -s /bin/true /sbin/initctl

# Update APT packages
RUN apt-get update && apt-get upgrade -y -o DPkg::Options::=--force-confold

# Install The Salt Debian Repository
RUN apt-get install -y -o DPkg::Options::=--force-confold wget && \
  wget -q -O- "http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add - && \
  echo "deb http://debian.saltstack.com/debian jessie-saltstack main" > /etc/apt/sources.list.d/saltstack.list

# Upgrade The System
RUN apt-get update && apt-get upgrade -y -o DPkg::Options::=--force-confold

# Install Salt Dependencies
RUN apt-get install -y -o DPkg::Options::=--force-confold python
RUN apt-get install -y -o DPkg::Options::=--force-confold apt-utils
RUN apt-get install -y -o DPkg::Options::=--force-confold python-software-properties
RUN apt-get install -y -o DPkg::Options::=--force-confold software-properties-common
RUN apt-get install -y -o DPkg::Options::=--force-confold salt-minion

VOLUME ["/srv/salt", "/srv/pillar", "/etc/salt/minion.d"]