include:
  - php5.modules

libapache2-mod-php5:
  pkg:
    - installed

/etc/php5/apache2/php.ini_expose:
  file.sed:
    - names: 
      - /etc/php5/apache2/php.ini
      - /etc/php5/cli/php.ini
    - before: '^expose_php = On$'
    - after: 'expose_php = Off'
    - require:
      - pkg: php5-pkg
    - watch_in:
      - service: apache2

/etc/php5/apache2/php.ini_allow_url_fopen:
  file.sed:
    - names: 
      - /etc/php5/apache2/php.ini
      - /etc/php5/cli/php.ini
    - before: '^allow_url_fopen = On$'
    - after: 'allow_url_fopen = Off'
    - require:
      - pkg: php5-pkg
    - watch_in:
      - service: apache2

/etc/php5/apache2/php.ini_upload_max_filesize:
  file.sed:
    - names: 
      - /etc/php5/apache2/php.ini
      - /etc/php5/cli/php.ini
    - before: '^upload_max_filesize = 2M$'
    - after: 'upload_max_filesize = 64M'
    - require:
      - pkg: php5-pkg
    - watch_in:
      - service: apache2

/etc/php5/apache2/php.ini_post_max_size:
  file.sed:
    - names: 
      - /etc/php5/apache2/php.ini
      - /etc/php5/cli/php.ini
    - before: '^post_max_size = 8M$'
    - after: 'post_max_size = 64M'
    - require:
      - pkg: php5-pkg
    - watch_in:
      - service: apache2
