class php_web::php {
  $php_mysql = $::osfamily ? {
    'Debian' => 'php5-mysql',
    default  => 'php-mysql',
  }

  $php_memcache = $::osfamily ? {
    'Debian' => 'php5-memcache',
    default  => 'php-memcache',
  }

  package { [ $php_mysql, $php_memcache ]:
    ensure => present,
  }

  class { 'php::fpm::daemon':
    ensure    => present,
    log_level => 'warn',
  }

  php::fpm::conf { 'www':
    ensure => absent,
  }

  php::ini { '/etc/php5/fpm/php.ini':
    ensure               => present,
    template             => 'local_wm/php.ini.erb',
    disable_functions    => 'phpinfo,eval,exec,shell_exec',
    session_save_handler => $::php_web::php_session_handler,
    session_save_path    => $::php_web::php_session_path,
  }
}
