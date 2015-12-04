# installs php5-module for apache and manages configurations

# includes apache.server and php5.modules
include:
  - apache.server
  - php5.modules
  - requisites

# installs apache2 php5-module
libapache2-mod-php5:
  pkg:
    - installed


/etc/php5/apache2/php.ini:
  file.blockreplace:
    - name: /etc/php5/apache2/php.ini
    - marker_start: "### START SALT MANAGED ZONE ###"
    - marker_end: "### END SALT MANAGED ZONE ###"
    - content: |
        expose_php = Off
        allow_url_fopen = Off
        upload_max_filesize = 64M
        post_max_size = 64M
    - append_if_not_found: True
    - backup: '.bak'
    - show_changes: True
    - require:
      - pkg: php5-pkg
    - watch_in:
      - service: apache2


installed-packages-php5-mod:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - libapache2-mod-php5
    - require_in:
      - file: /root/saltdoc/installed_packages.rst