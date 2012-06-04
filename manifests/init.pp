# Class: haproxy
#
#   This module manages the HAProxy service.
#
#   Adrian Webb <adrian.webb@coraltg.com>
#   2012-05-22
#
#   Tested platforms:
#    - Ubuntu 12.04
#
# Parameters:
#
#  $haproxy_package         = $haproxy::params::haproxy_package,
#  $haproxy_version         = $haproxy::params::haproxy_version,
#  $user                    = $haproxy::params::user,
#  $group                   = $haproxy::params::group,
#  $debug                   = $haproxy::params::debug,
#  $quiet                   = $haproxy::params::quiet,
#  $max_connections         = $haproxy::params::max_connections,
#  $default_mode            = $haproxy::params::default_mode,
#  $default_retries         = $haproxy::params::default_retries,
#  $default_max_connections = $haproxy::params::default_max_connections,
#  $default_options         = $haproxy::params::default_options,
#  $proxies                 = $haproxy::params::proxies,
#  $proxy_config            = $haproxy::params::proxy_config,
#
# Actions:
#
#  Installs, configures, and manages the HAProxy service.
#
# Requires:
#
# Sample Usage:
#
#   $server_settings = [
#     'check',
#     [ 'port', 9200 ],
#     [ 'inter', 12000 ],
#     [ 'rise', 3 ],
#     [ 'fall', 3 ],
#     'backup',
#   ]
#
#   $proxy_options = {
#     'httpchk' => [ ],
#   }
#
#   $servers = {
#     'percona1'   => {
#       'ip'       => 192.168.70.2,
#       'port'     => 3306,
#       'settings' => $server_settings,
#     },
#     'percona2'   => {
#       'ip'       => 192.168.70.3,
#       'port'     => 3306,
#       'settings' => $server_settings,
#     },
#     'percona3'   => {
#       'ip'       => 192.168.70.4,
#       'port'     => 3306,
#       'settings' => $server_settings,
#     },
#   }
#
#   $proxies = {
#     'cluster-writes' => {
#       'port'         => 43555,
#       'mode'         => 'tcp',
#       'balance'      => 'leastconn',
#       'options'      => $proxy_options,
#       'servers'      => $servers,
#     },
#     'cluster-reads' => {
#       'port'        => 43570,
#       'mode'        => 'tcp',
#       'balance'     => 'leastconn',
#       'options'     => $proxy_options,
#       'servers'     => $servers,
#     },
#   }
#
#   class { 'haproxy':
#     proxies => $proxies,
#   }
#
# [Remember: No empty lines between comments and class definition]
class haproxy (

  $haproxy_package         = $haproxy::params::haproxy_package,
  $haproxy_version         = $haproxy::params::haproxy_version,
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
  $proxy_config            = $haproxy::params::proxy_config,
)
inherits haproxy::params {

  #-----------------------------------------------------------------------------

  class { 'haproxy::firewall':
    proxies => $proxies,
  }

  class { 'haproxy::install':
    haproxy_package => $haproxy_package,
    haproxy_version => $haproxy_version,
  }

  class { 'haproxy::config':
    user                    => $user,
    group                   => $group,
    debug                   => $debug,
    quiet                   => $quiet,
    max_connections         => $max_connections,
    default_mode            => $default_mode,
    default_retries         => $default_retries,
    default_max_connections => $default_max_connections,
    default_options         => $default_options,
    proxies                 => $proxies,
    proxy_config            => $proxy_config,
  }

  class { 'haproxy::service':
    proxy_config => $proxy_config,
  }

  #-----------------------------------------------------------------------------

  Class['haproxy::firewall'] ->
  Class['haproxy::install'] ->
  Class['haproxy::config'] ->
  Class['haproxy::service']
}
