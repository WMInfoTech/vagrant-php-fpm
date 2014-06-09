class php_web::php {
  $php_mysql = $::osfamily ? {
    'Debian' => 'php5-mysql',
    default  => 'php-mysql',
  }

  package { $php_mysql:
    ensure => present,
  }

  class { 'php::fpm::daemon':
    ensure    => present,
    log_level => 'warn',
  }

  php::fpm::conf { 'www':
    ensure => absent,
  }
}
