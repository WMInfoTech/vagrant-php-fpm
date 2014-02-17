class { 'apt': }

class { 'php_web':
  webserver             => 'nginx',
  admin_email           => 'unix@wm.edu',
  apache_cas            => true,
  php_cas               => true,
  cas_login_url         => 'https://castst.wm.edu/cas/login',
  cas_validate_url      => 'https://castst.wm.edu/cas/serviceValidate',
  php_session_store     => 'memcache',
  php_session_save_path => 'tcp://localhost:11211?persistent=1&weight=2&timeout=2&retry_interval=10',
  require               => [ Package['memcached'], Class['mysql::server'] ]
}

php_web::vhost { 'vagrant.localhost':
  manage_user  => false,
  alt_root     => true,
  show_errors  => true,
  upload_limit => '30M',
  require      => Class['php_web'],
}

host { 'webdb.wm.edu':
  ip => '127.0.0.1',
}

package { 'memcached':
  ensure => installed,
}

apt::source { 'mariadb':
  key         => 'cbcb082a1bb943db',
  key_server  => 'keyserver.ubuntu.com',
  location    => 'http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu',
  release     => $::lsbdistcodename,
  repos       => 'main',
  include_src => false,
}

class { 'mysql::server':
  package_name     => 'mariadb-server',
  root_password    => 'UNSET',
  require          => Apt::Source['mariadb'],
  override_options => { 'mysqld' => 
                        { 'bind-address' => '0.0.0.0' }
                      },
}
