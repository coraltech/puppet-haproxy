
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
    'tcplog'                => [],
    'dontlognull'           => [],
    'redispatch'            => [],
  }

  $proxies                 = {}

  #---

  case $::operatingsystem {
    debian, ubuntu: {
      $os_haproxy_package = 'haproxy'
      $os_haproxy_service = 'haproxy'

      $os_config          = '/etc/haproxy/haproxy.cfg'
      $os_config_template = 'haproxy/haproxy.cfg.erb'

      $os_chroot_dir      = '/usr/share/haproxy'
    }
    default: {
      fail("The haproxy module is not currently supported on ${::operatingsystem}")
    }
  }
}
