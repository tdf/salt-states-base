from stackbrew/centos:7

# Install EPEL
RUN yum -y install epel-release

# Update Current Image
RUN yum update -y

# Install Salt Dependencies
RUN yum -y install --enablerepo=epel salt-minion

VOLUME ["/srv/salt", "/srv/pillar", "/etc/salt/minion.d"]