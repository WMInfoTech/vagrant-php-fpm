# Private Class
class php_web::apache {
  if $::lsbdistcodename == 'trusty' {
    apt::source { 'multiverse':
      location => 'http://archive.ubuntu.com/ubuntu',
      repos    => 'multiverse',
      before   => Class['::apache'],
    }

    apt::source { 'multiverse-updates':
      location => 'http://archive.ubuntu.com/ubuntu',
      repos    => 'multiverse',
      release  => 'trusty-updates',
      before   => Class['::apache'],
    }
  }

  class { '::apache':
    default_vhost => false,
    default_mods  => [
      'actions',
      'alias',
      'auth_basic',
      'dir',
      'fastcgi',
      'headers',
      'mime',
      'rewrite',
    ],
  }
}
