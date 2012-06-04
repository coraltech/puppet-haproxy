
class haproxy::install (

  $haproxy_package = $haproxy::params::haproxy_package,
  $haproxy_version = $haproxy::params::haproxy_version,
)
inherits haproxy::params {

  #-----------------------------------------------------------------------------

  if ! $haproxy_package or ! $haproxy_version {
    fail('HAProxy package name and version must be defined')
  }
  package {	$haproxy_package:
    ensure => $haproxy_version,
  }
}

