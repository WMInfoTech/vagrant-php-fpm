class php_web (
  $serveradmin         = 'root@localhost',
  $service_ensure      = 'running',
  $webserver           = $::php_web::params::webserver,
  $vhost_root          = '/var/www',
  $php_session_handler = 'memcache',
  $php_session_path    = 'tcp://localhost:11211?persistent=1&weight=2&timeout=2&retry_interval=10',
) inherits ::php_web::params {

  validate_string($serveradmin, $service_ensure, $webserver)

  class { 'php::fpm::daemon':
    ensure    => present,
    log_level => 'warn',
  }

  php::fpm::conf { 'www':
    ensure => absent,
  }

  if $webserver == 'apache' {
    class { '::php_web::apache':
      require => Class['php::fpm::daemon']
    }
  } elsif $webserver == 'nginx' {
    fail('nginx is not supported yet')
  }
  

}  
