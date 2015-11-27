{% for file in [ '/etc/postfix/main.cf',
'/etc/postfix/transports',
'/etc/postfix/recipients',
'/etc/postfix/client_access',
'/etc/postfix/helo_access',
'/etc/postfix/identity_abuse',
'/etc/postfix/postscreen_access',
'/etc/postfix/roles',
'/etc/postfix/rbl_exceptions',
'/etc/postfix/valid_senders',
'/etc/dovecot/users',
'/etc/postfix/master.cf',
'/etc/default/amavisd-milter',
'/etc/clamav/clamd.conf' ] %}
{{ file }}:
  file:
    - managed
    - content: ''
{% endfor %}
