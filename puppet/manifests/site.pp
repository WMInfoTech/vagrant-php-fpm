class { 'apt': }

class { 'php_web':
  serveradmin => 'unix@wm.edu',
}

php_web::vhost { 'vagrant.localhost':
#  apache_def => { 'fallbackresource' => '/index.php' },
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
  location    => 'http://ftp.osuosl.org/pub/mariadb/repo/10.0/ubuntu',
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
