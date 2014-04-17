# this file is managed by salt
include includes/ssl;
ssl_certificate {{ crt }};
ssl_certificate_key {{ key }};
{% if ocsp %}
ssl_stapling on;
ssl_stapling_file {{ ocsp }};
{% endif %}