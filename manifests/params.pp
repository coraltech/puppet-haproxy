
class haproxy::params {

  include haproxy::default

  #-----------------------------------------------------------------------------
  # General configurations

  if $::hiera_ready {
    $haproxy_package_ensure  = hiera('haproxy_package_ensure', $haproxy::default::haproxy_package_ensure)
    $haproxy_service_ensure  = hiera('haproxy_service_ensure', $haproxy::default::haproxy_service_ensure)
    $configure_firewall      = hiera('haproxy_configure_firewall', $haproxy::default::configure_firewall)
    $user                    = hiera('haproxy_user', $haproxy::default::user)
    $group                   = hiera('haproxy_group', $haproxy::default::group)
    $node                    = hiera('haproxy_node', $haproxy::default::node)
    $debug                   = hiera('haproxy_debug', $haproxy::default::debug)
    $quiet                   = hiera('haproxy_quiet', $haproxy::default::quiet)
    $max_connections         = hiera('haproxy_max_connections', $haproxy::default::max_connections)
    $default_mode            = hiera('haproxy_default_mode', $haproxy::default::default_mode)
    $default_retries         = hiera('haproxy_default_retries', $haproxy::default::default_retries)
    $default_max_connections = hiera('haproxy_default_max_connections', $haproxy::default::default_max_connections)
    $default_options         = hiera_hash('haproxy_default_options', $haproxy::default::default_options)
    $proxies                 = hiera_hash('haproxy_proxies', $haproxy::default::proxies)
  }
  else {
    $haproxy_package_ensure  = $haproxy::default::haproxy_package_ensure
    $haproxy_service_ensure  = $haproxy::default::haproxy_service_ensure
    $configure_firewall      = $haproxy::default::configure_firewall
    $user                    = $haproxy::default::user
    $group                   = $haproxy::default::group
    $node                    = $haproxy::default::node
    $debug                   = $haproxy::default::debug
    $quiet                   = $haproxy::default::quiet
    $max_connections         = $haproxy::default::max_connections
    $default_mode            = $haproxy::default::default_mode
    $default_retries         = $haproxy::default::default_retries
    $default_max_connections = $haproxy::default::default_max_connections
    $default_options         = $haproxy::default::default_options
    $proxies                 = $haproxy::default::proxies
  }

  #-----------------------------------------------------------------------------
  # Operating system specific configurations

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
