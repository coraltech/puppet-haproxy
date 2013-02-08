
class haproxy::default {

  $package_ensure          = 'present'
  $service_ensure          = 'running'

  $configure_firewall      = 'true'

  $user                    = 'haproxy'
  $group                   = 'haproxy'

  $node                    = $::hostname
  $debug                   = 'false'
  $quiet                   = 'false'
  $max_connections         = 5000

  $default_mode            = 'http'
  $default_retries         = 3
  $default_max_connections = 1000
  $default_options         = {
    'tcplog'                => '',
    'dontlognull'           => '',
    'redispatch'            => '',
  }

  $default_timeouts        = {
    'connect'               => '5000ms',
    'client'                => '50000ms',
    'server'                => '50000ms',
  }

  $proxies                 = {}

  #---

  case $::operatingsystem {
    debian, ubuntu: {
      $package                 = 'haproxy'
      $service                 = 'haproxy'

      $default_config          = '/etc/default/haproxy'
      $default_config_template = 'haproxy/default.erb'

      $config                  = '/etc/haproxy/haproxy.cfg'
      $config_template         = 'haproxy/haproxy.cfg.erb'

      $chroot_dir              = '/usr/share/haproxy'
    }
    default: {
      fail("The haproxy module is not currently supported on ${::operatingsystem}")
    }
  }
}
