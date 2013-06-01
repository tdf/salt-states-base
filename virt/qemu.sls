virt-qemu-packages:
  pkg:
    - installed
    - names:
      - qemu-kvm
      - libvirt-bin

net.ipv4.ip_forward:
  sysctl:
    - present
    - value: 1

net.ipv6.conf.all.forwarding:
  sysctl:
    - present
    - value: 1

net.ipv4.conf.default.rp_filter:
  sysctl:
    - present
    - value: 1

net.ipv4.conf.all.rp_filter:
  sysctl:
    - present
    - value: 1

net.ipv4.tcp_syncookies:
  sysctl:
    - present
    - value: 1

