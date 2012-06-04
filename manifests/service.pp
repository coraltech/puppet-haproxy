
class haproxy::service (

  $proxy_config = $haproxy::params::proxy_config,
)
inherits haproxy::params {

  #-----------------------------------------------------------------------------

  service { 'haproxy':
    ensure    => 'running',
    require	  => Class['haproxy::config'],
    subscribe => File[$proxy_config]
	}
}
