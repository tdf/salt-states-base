include:
  - php5.modules

php5-fpm:
  service:
    - running
    - enabled: true    
    - reload: true
  pkg:
    - installed

/etc/php5/fpm/php.ini_expose:
  file.sed:
    - names: 
      - /etc/php5/fpm/php.ini
      - /etc/php5/cli/php.ini
    - before: '^expose_php = On$'
    - after: 'expose_php = Off'
    - require:
      - pkg: php5-pkg
      - pkg: php5-fpm
    - watch_in:
      - service: php5-fpm

/etc/php5/fpm/php.ini_allow_url_fopen:
  file.sed:
    - names: 
      - /etc/php5/fpm/php.ini
      - /etc/php5/cli/php.ini
    - before: '^allow_url_fopen = On$'
    - after: 'allow_url_fopen = Off'
    - require:
      - pkg: php5-pkg
      - pkg: php5-fpm
    - watch_in:
      - service: php5-fpm

/etc/php5/fpm/php.ini_upload_max_filesize:
  file.sed:
    - names: 
      - /etc/php5/fpm/php.ini
      - /etc/php5/cli/php.ini
    - before: '^upload_max_filesize = 2M$'
    - after: 'upload_max_filesize = 64M'
    - require:
      - pkg: php5-pkg
      - pkg: php5-fpm
    - watch_in:
      - service: php5-fpm

/etc/php5/fpm/php.ini_post_max_size:
  file.sed:
    - names: 
      - /etc/php5/fpm/php.ini
      - /etc/php5/cli/php.ini
    - before: '^post_max_size = 8M$'
    - after: 'post_max_size = 64M'
    - require:
      - pkg: php5-pkg
      - pkg: php5-fpm
    - watch_in:
      - service: php5-fpm
