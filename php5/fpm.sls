# installs php5 as FPM for supporting nginx

# includes php5.modules
include:
  - php5.modules
  - requisites

# installs php5-fpm and manages service for php5-fpm
php5-fpm:
  service:
    - running
    - enable: true    
    - reload: true
  pkg:
    - installed

/etc/php5/fpm/php.ini:
  file.blockreplace:
    - name: /etc/php5/fpm/php.ini
    - marker_start: ";;; START SALT MANAGED ZONE ;;;"
    - marker_end: ";;; END SALT MANAGED ZONE ;;;"
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
      - pkg: php5-fpm
    - watch_in:
      - service: php5-fpm

installed-packages-php5-fpm:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - php5-fpm
    - require_in:
      - file: /root/saltdoc/installed_packages.rst