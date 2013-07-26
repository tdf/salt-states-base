================
Salt User Module
================

This salt-user-module is responsible for Managing Users.

Pillar
======

For using this Module you need a corresponding pillar/user. The structure of the pillar/users/init.sls should look like this:

.. code-block:: yaml

  users:
    <USER-NAME>:
      uid: <UID>
      fullname: <NAME>
      email: <EMAIL>
      password: <CRYPTED-PW>
      shell: /bin/bash
      groups:
        - wheel
        - kvm
        - libvirt
        - sudo
      ssh_auth:
        - key: <KEY>
          type: ssh-rsa
          comment: <KEY-COMMENT>
      absent_ssh_auth:
        - <KEY>
        - <KEY>
    <USER-NAME>:
      ..
  absent_users:
    - <USER-NAME>
    - <USER-NAME>
  absent_root_ssh_auth:
    - <KEY>
    - <KEY>


To generate the Password you can use mkpasswd

.. code-block:: bash

  mkpasswd --method=sha-512 --salt=$(pwgen 8 1)

git
===

Managging .gitconfig for users for configuring git-stuff.

init
====

The init.sls is to create and update the useraccounts found in the corresponding users-pillar. If an ssh-key is in users-pillar includes, the ssh-key will be included ~/.ssh/authorized_keys.

root
====

The root.sls collects all the ssh-key and appends them to ~root/.ssh/authorized_keys.

License
=======

Ths Code is distributed under Apache 2.0 License

.. _`Apache 2.0 license`: http://www.apache.org/licenses/LICENSE-2.0.html

