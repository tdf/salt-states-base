'''
Work with virtual machines manages by libvirt

:maintainer:  Robert Einsle <robert.einsle@mawoh.de>
:depends: libvirt Python module
'''

try:
    import libvirt

    HAS_LIBVIRT = True
except ImportError:
    HAS_LIBVIRT = False

def __virtual__():
    if not HAS_LIBVIRT:
        return False
    return 'vm'

# Create new VMs on virtualizers
def create(hostname,
           ipaddress,
           netmask=None,
           gateway=None,
           bridge=None,
           domain=None,
           interface=None,
           nameserver=None,
           ntpserver=None,
           proxy=None,
           location=None,
           preseed_url=None,
           ram=None,
           vcpus=None,
           vg_name=None,
           lv_name=None,
           lv_size=None):
    '''
    Create new VMs

    :param hostname: name of the vm to be created
    :param ipaddress: the ipaddress the new created vm will use
    :param netmask: the netmask of the ipaddress
    :param gateway: the default gateway the vm will use
    :param bridge: the bridge the network-interface will be created on
        (defaults to br0)
    :param domain: the domain-name of the host
    :param interface: the interface insite the vm that will be configured
        (defaults to eth0)
    :param nameserver: the nameserver the vm will use
    :param ntpserver: the ntpserver the vm will use
    :param proxy: the proxyserver the vm will use
    :param location: the location (url) of the installer
        (defaults to http://ftp.de.debian.org/debian/dists/wheezy/main/installer-amd64/)
    :param preseed_url: url of the preseed-file for the installation
        (defaults to http://www.einsle.de/wheezy-test.cfg)
    :param ram: the amount of ram in mb the vm will be have
        (defaults to 1024)
    :param vcpus: the amount of virtual cpus the vm will be have
        (defaults to 1)
    :param vg_name: the volume_group the vm will be installed in
        (defaults to vg_data)
    :param lv_name: the new lv name for the vm
        (defaults to lv_{hostname})
    :param lv_size: the size in GB the image for the vm will be created
        (defaults to 10)

    CLI Example::
      
      salt '*' vm.create hostname='<name>' ip_address='10.0.0.2' netmask='255.255.255.0' gateway='10.0.0.1'
    '''
    if netmask is None:
        netmask = __salt__['pillar.get']('vm:netmask', '')
    if gateway is None:
        gateway = __salt__['pillar.get']('vm:gateway', '')
    if bridge is None:
        bridge = __salt__['pillar.get']('vm:bridge', 'br0')
    if domain is None:
        domain = __salt__['pillar.get']('vm:domain', '')
    if interface is None:
        interface = __salt__['pillar.get']('vm:interface', 'eth0')
    if nameserver is None:
        nameserver = __salt__['pillar.get']('vm:nameserver', '')
    if ntpserver is None:
        ntpserver = __salt__['pillar.get']('vm:ntpserver', '')
    if proxy is None:
        proxy = __salt__['pillar.get']('vm:proxy', '')
    if location is None:
        location = __salt__['pillar.get']('vm:location',
                                          'http://ftp.de.debian.org/debian/dists/wheezy/main/installer-amd64/')
    if preseed_url is None:
        preseed_url = __salt__['pillar.get']('vm:preseed_url', 'http://www.einsle.de/wheezy-test.cfg')
    if ram is None:
        ram = __salt__['pillar.get']('vm:ram', '1024')
    if vcpus is None:
        vcpus = __salt__['pillar.get']('vm:vcpus', '1')
    if vg_name is None:
        vg_name = __salt__['pillar.get']('vm:vg_name', 'vg_data')
    if lv_name is None:
        lv_name = __salt__['pillar.get']('vm:lv_name', 'lv_{}'.format(hostname))
    if lv_size is None:
        lv_size = __salt__['pillar.get']('vm:lv_size', '10')
    # Build the command to create the vm
    virt_install = ['virt-install',
                    '--name="{}"'.format(hostname),
                    '--ram="{}"'.format(ram),
                    '--vcpus="{}"'.format(vcpus),
                    '--cpu="host"',
                    '--os-type="linux"',
                    '--virt-type="kvm"',
                    '--noautoconsole',
                    '--wait=-1',
                    '--hvm',
                    '--network="bridge:{},model=virtio"'.format(bridge),
                    '--graphics="vnc,keymap=de"',
                    '--disk="/dev/{}/{},size={},bus=virtio"'.format(vg_name, lv_name, lv_size),
                    '--location="{}"'.format(location),
                    '--extra-args="auto=true',
                    'hostname={}'.format(hostname),
                    'domain={}'.format(domain),
                    'interface={}'.format(interface),
                    'netcfg/disable_dhcp=true',
                    'netcfg/disable_autoconfig=true',
                    'netcfg/get_nameservers={}'.format(nameserver),
                    'netcfg/get_ipaddress={}'.format(ipaddress),
                    'netcfg/get_netmask={}'.format(netmask),
                    'netcfg/get_gateway={}'.format(gateway),
                    'netcfg/confirm_static=true',
                    'clock-setup/ntp-server={}'.format(ntpserver),
                    'mirror/http/proxy={}'.format(proxy),
                    'url={}"'.format(preseed_url)]
    virt_install = ' '.join(virt_install)
    return __salt__['cmd.run'](virt_install)
