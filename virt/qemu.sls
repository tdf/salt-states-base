include:
  - requisites

# installs qemu packages
virt-qemu-packages:
  pkg:
    - installed
    - names:
      - qemu-kvm
      - libvirt-bin
      - sysfsutils

sysfs_ksm:
  file:
    - append
    - name: /etc/sysfs.conf
    - text: |
        kernel/mm/ksm/run = 1
        kernel/mm/ksm/pages_to_scan = 20000
    - require:
        - pkg: virt-qemu-packages
  service:
    - running
    - name: sysfsutils
    - enable: True
    - watch:
        - file: sysfs_ksm

# enable ipv4 forwarding
net.ipv4.ip_forward:
  sysctl:
    - present
    - value: 1

# enable ipv6 all forwarding
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

installed-packages-virt-qemu:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - qemu-kvm
      - libvirt-bin
    - require_in:
      - file: /root/saltdoc/installed_packages.rst