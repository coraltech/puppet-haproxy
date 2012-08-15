
class haproxy::params inherits haproxy::default {

  $package                 = module_param('package')
  $package_ensure          = module_param('package_ensure')
  $service                 = module_param('service')
  $service_ensure          = module_param('service_ensure')

  #---

  $configure_firewall      = module_param('configure_firewall')

  $config                  = module_param('config')
  $config_template         = module_param('config_template')
  $chroot_dir              = module_param('chroot_dir')

  $user                    = module_param('user')
  $group                   = module_param('group')
  $node                    = module_param('node')

  $debug                   = module_param('debug')
  $quiet                   = module_param('quiet')
  $max_connections         = module_param('max_connections')

  $default_mode            = module_param('default_mode')
  $default_retries         = module_param('default_retries')
  $default_max_connections = module_param('default_max_connections')
  $default_options         = module_hash('default_options')

  $proxies                 = module_hash('proxies')
}
