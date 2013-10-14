==========
SSH Module
==========

This salt-ssh-module is responsible for ssh client and server management.

client
------

The client.sls installs openssh-client and managed ssh_config.

server
------

The server.sls installs needed openssh-server and openssh-blacklist and manages /etc/ssh/sshd_config.

init
----

The init.sls includes client and server, so if only ssh is included, client and server will be installed.
