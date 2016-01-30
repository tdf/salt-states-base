from stackbrew/ubuntu:precise

RUN apt-get update && apt-get upgrade -y -o DPkg::Options::=--force-confold

# Add the Salt PPA
RUN apt-get install -y apt-utils python-software-properties && apt-add-repository -y ppa:saltstack/salt && apt-get update

# Install Salt Dependencies
RUN apt-get install -y -o DPkg::Options::=--force-confold salt-minion

VOLUME ["/srv/salt", "/srv/pillar", "/etc/salt/minion.d"]