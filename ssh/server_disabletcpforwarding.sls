sshd-config-disable-tcp-forwarding:
  file.accumulated:
    - name: sshd_config
    - filename: /etc/ssh/sshd_config
    - text:
        - AllowTcpForwarding no
    - require_in:
        - file: /etc/ssh/sshd_config