
class haproxy::params {

  $user   = 'haproxy'
  $group  = 'haproxy'
  $node   = $::hostname

  $debug = false
  $quiet = false

  $max_connections = 5000

  $default_mode            = 'http'
  $default_retries         = 3
  $default_max_connections = 1000

  $default_options = {
    'tcplog'      => [ ],
    'dontlognull' => [ ],
    'redispatch'  => [ ],
  }

  $proxies = {}

  case $::operatingsystem {
    debian: {}
    ubuntu: {
      $haproxy_package = 'haproxy'
      $haproxy_version = '1.4.18-0ubuntu1'
      $proxy_config    = '/etc/haproxy/haproxy.cfg'
    }
    centos: {}
    redhat: {}
  }
}
