/etc/login.defs:
  file.blockreplace:
    - name: /etc/login.defs
    - marker_start: "### START SALT MANAGED ZONE ###"
    - marker_end: "### END SALT MANAGED ZONE ###"
    - content: |
        LOG_OK_LOGINS yes
        CHFN_RESTRICT
        USERGROUPS_ENAB no
    - append_if_not_found: True
    - backup: '.bak'
    - show_changes: True

{% if grains['os_family'] == "Debian" %}
# change adduser not to create usergroups
/etc/adduser.conf:
  file.blockreplace:
    - name: /etc/adduser.conf
    - marker_start: "### START SALT MANAGED ZONE ###"
    - marker_end: "### END SALT MANAGED ZONE ###"
    - content: |
        USERGROUPS=no
        DIR_MODE=0711
    - append_if_not_found: True
    - backup: '.bak'
    - show_changes: True

{% endif %}
