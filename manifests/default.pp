
class haproxy::default {
  $haproxy_package_ensure  = 'present'
  $haproxy_service_ensure  = 'running'
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
}
