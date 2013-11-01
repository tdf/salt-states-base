include:
  - requisites

# installs virsh client modules
virt-client-packages:
  pkg:
    - installed
    - names:
      - libvirt-bin
      - virtinst
      - virt-manager

installed-packages-virt-client:
  file.accumulated:
    - name: installed_packages
    - filename: /root/saltdoc/installed_packages.rst
    - text:
      - libvirt-bin
      - virtinst
      - virt-manager
    - require_in:
      - file: /root/saltdoc/installed_packages.rst