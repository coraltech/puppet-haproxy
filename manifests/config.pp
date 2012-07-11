
class haproxy::config (

  $user                    = $haproxy::params::user,
  $group                   = $haproxy::params::group,
  $debug                   = $haproxy::params::debug,
  $quiet                   = $haproxy::params::quiet,
  $max_connections         = $haproxy::params::max_connections,
  $default_mode            = $haproxy::params::default_mode,
  $default_retries         = $haproxy::params::default_retries,
  $default_max_connections = $haproxy::params::default_max_connections,
  $default_options         = $haproxy::params::default_options,
  $proxies                 = $haproxy::params::proxies,

) inherits haproxy::params {

  $proxy_config            = $haproxy::params::proxy_config

  #-----------------------------------------------------------------------------

  file { $proxy_config:
    ensure  => 'present',
    require => Class['haproxy::install'],
    content => template('haproxy/haproxy.cfg.erb'),
  }
}
