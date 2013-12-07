base:
  'P@os:(Debian|Ubuntu)':
    - match: compound
    - apache
    - apt
    - console
    - debian
    - editor
    - etckeeper
    - fail2ban
    - locales
    - nginx
    - ntp
    - packages
    - php5
    - postgres
    - python
    - quagga
    - radius
    - requisites
    - rsyslog
    - salt
    - sentry
    - shorewall
    - squid
    - ssh
    - supervisor
    - timezone
    - users
    - util
    - uwsgi
    - virt
  'P@os:(CentOS|Fedora)':
    - match: compound
    - requisites


# Local Variables:
# mode: yaml
# End:
