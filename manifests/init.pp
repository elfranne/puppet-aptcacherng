#
# == Class: aptcacherng
#
# Setup apt-cacher-ng, an apt repository proxy server
#
# Note that older versions of apt-cacher-ng - such as the one bundled in Ubuntu 
# 12.04 - have a nasty bug:
#
# <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=676214>
#
# If you use this module on a platform that does not provide an up-to-date 
# version of apt-cacher-ng by default, it's suggested to activate the backports 
# repos using the apt::proxy class or some other mechanism, and upgrading 
# apt-cacher-ng manually.
#
# == Parameters
#
# [*manage*]
#   Manage apt-cacher-ng with Puppet. Valid values are true (default) and false.
# [*manage_packetfilter*]
#   Manage packet filtering rules. Valid values are true (default) and false.
# [*manage_monit*]
#   Manage monit rules. Valid values are true (default) and false.
# [*listen_addresses*]
#   A space-separated list of IP address to listen on (see "BindAddress" in 
#   apt-cacher-ng documentation). For example '0.0.0.0', 'server.domain.com' or 
#   'localhost'. Defaults to 'localhost'
# [*port*]
#   The TCP port to listen on. Defaults to 3142.
# [*allow_address_ipv4*]
#   IPv4 address or address range to allow connections from. Defaults to 
#   '127.0.0.1'.
# [*allow_address_ipv6*]
#   IPv4 address or address range to allow connections from. Defaults to '::1'.
# [*monitor_email*]
#   Email address where local service monitoring software sends it's reports to. 
#   Defaults to global variable $::servermonitor.
#
# == Examples
#
#   include aptcacherng
#
# == Authors
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-lisence. See file LICENSE for details.
#
class aptcacherng
(
    Boolean $manage = true,
    Boolean $manage_packetfilter = true,
    Boolean $manage_monit = true,
    $listen_addresses = 'localhost',
    $port = 3142,
    $allow_address_ipv4 = '127.0.0.1',
    $allow_address_ipv6 = '::1',
    $monitor_email = $::servermonitor
)
{

if $manage {

    include ::aptcacherng::install

    class { '::aptcacherng::config':
        listen_addresses => $listen_addresses,
        port             => $port,
    }

    include ::aptcacherng::service

    if $manage_monit {
        class { '::aptcacherng::monit':
            monitor_email => $monitor_email,
        }
    }

    if $manage_packetfilter {

        class { '::aptcacherng::packetfilter':
            allow_address_ipv4 => $allow_address_ipv4,
            allow_address_ipv6 => $allow_address_ipv6,
            port               => $port,
        }
    }

}
}
