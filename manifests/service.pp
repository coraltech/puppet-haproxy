
class haproxy::service inherits haproxy::params {

  $proxy_config = $haproxy::params::proxy_config

  #-----------------------------------------------------------------------------

  service { 'haproxy':
    ensure    => 'running',
    require	  => Class['haproxy::config'],
    subscribe => File[$proxy_config]
	}
}
