# Class: haproxy
#
#   This module manages the HAProxy service.
#
#   Adrian Webb <adrian.webb@coraltech.net>
#   2012-05-22
#
#   Tested platforms:
#    - Ubuntu 12.04
#
# Parameters: (see <example/params.json> for Hiera configurations)
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

  $package                 = $haproxy::params::package,
  $package_ensure          = $haproxy::params::package_ensure,
  $service                 = $haproxy::params::service,
  $service_ensure          = $haproxy::params::service_ensure,
  $config                  = $haproxy::params::config,
  $config_template         = $haproxy::params::config_template,
  $configure_firewall      = $haproxy::params::configure_firewall,
  $chroot_dir              = $haproxy::params::chroot_dir,
  $user                    = $haproxy::params::user,
  $group                   = $haproxy::params::group,
  $node                    = $haproxy::params::node,
  $haproxy_debug           = $haproxy::params::debug,
  $haproxy_quiet           = $haproxy::params::quiet,
  $max_connections         = $haproxy::params::max_connections,
  $default_mode            = $haproxy::params::default_mode,
  $default_retries         = $haproxy::params::default_retries,
  $default_max_connections = $haproxy::params::default_max_connections,
  $default_options         = $haproxy::params::default_options,
  $proxies                 = $haproxy::params::proxies,

) inherits haproxy::params {

  $proxy_ports             = proxy_ports($proxies)

  #-----------------------------------------------------------------------------
  # Installation

  if ! ( $package and $package_ensure ) {
    fail('HAProxy package name and ensure value must be defined')
  }
  package { 'haproxy':
    name   => $package,
    ensure => $package_ensure,
  }

  #-----------------------------------------------------------------------------
  # Configuration

  if $configure_firewall == 'true' and $proxy_ports {
    haproxy::rule { $proxy_ports: }
  }

  file { 'haproxy-config':
    path    => $config,
    content => template($config_template),
    require => Package['haproxy'],
    notify  => Service['haproxy'],
  }

  #-----------------------------------------------------------------------------
  # Services

  service { 'haproxy':
    name    => $service,
    ensure  => $service_ensure,
    require => Package['haproxy'],
  }
}

#-------------------------------------------------------------------------------

define haproxy::rule( $port = $name ) {

  $rule_description = "200 INPUT Allow HAProxy connections: $port"

  #-----------------------------------------------------------------------------

  if $port and ! defined(Firewall[$rule_description]) {
    firewall { $rule_description:
      action => accept,
      chain  => 'INPUT',
      state  => 'NEW',
      proto  => 'tcp',
      dport  => $port,
    }
  }
}

