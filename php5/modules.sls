# defines php5 modules to be installed
php5-pkg:
  pkg:
    - installed
    - names:
      - php5-cli
      - php5-gd
      - php5-imap
      - php5-ldap
      - php5-mcrypt
      - php5-mysql
      - php5-pgsql

installed-packages-php5-modules:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - php5-cli
      - php5-gd
      - php5-imap
      - php5-ldap
      - php5-mcrypt
      - php5-mysql
      - php5-pgsql
    - require_in:
      - file: /root/saltdoc/installed_packages.rst