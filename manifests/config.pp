#
# == Class: aptcacherng::config
#
# Configure apt-cacher-ng
#
class aptcacherng::config
(
    $listen_addresses,
    $port,
    $cache_dir,
    $pass_through_pattern,

) inherits aptcacherng::params
{

    file { 'acng.conf':
        ensure  => present,
        name    => $::aptcacherng::params::config_name,
        content => template('aptcacherng/acng.conf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['aptcacherng::install'],
        notify  => Class['aptcacherng::service'],
    }


    file { 'zzz_override.conf':
        ensure  => present,
        name    => $::aptcacherng::params::config_name,
        content => "CacheDir: ${cache_dir}",
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['aptcacherng::install'],
        notify  => Class['aptcacherng::service'],
    }
}
