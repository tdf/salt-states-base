# installs php5 as FPM for supporting nginx

# includes php5.modules
include:
  - php5.modules

# installs php5-fpm and manages service for php5-fpm
php5-fpm:
  service:
    - running
    - enable: true    
    - reload: true
  pkg:
    - installed

# defines expose_php off in php.ini
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

# disallow url_fopen in php.ini
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

# sets max_file_size in php.ini
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

# sets post_max_size in php.ini
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
