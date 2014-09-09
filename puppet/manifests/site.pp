class { 'apt': }

apt::source { 'mariadb':
  key         => 'cbcb082a1bb943db',
  key_server  => 'keyserver.ubuntu.com',
  location    => 'http://ftp.osuosl.org/pub/mariadb/repo/10.0/ubuntu',
  repos       => 'main',
  include_src => false,
}

class { 'php_web':
  php_ini_params => {
    session_save_handler => 'memcache',
    session_save_path    => 'tcp://localhost:11211?persistent=1&weight=2&timeout=2&retry_interval=10',
    disable_functions    => 'pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,exec,shell_exec,phpinfo,eval,system,passthru,proc_open,show_source,apache_child_terminate,apache_setenv,symlink,chgrp,chown,posix_getpwuid,posix_kill,posix_mkfifo,posix_setpgid,posix_setsid,posix_setuid,posix_setuid,posix_uname,proc_close,proc_nice,proc_terminate',
  }
}

php_web::vhost { 'vagrant.localhost':
 # apache_def => {
 #   fallbackresource => '/index.php',
 # }
}

host { 'mdbc1.wm.edu':
  ip => '127.0.0.1',
}

package { 'memcached':
  ensure => installed,
}

class { 'mysql::server':
  package_name     => 'mariadb-server',
  root_password    => 'UNSET',
  require          => Apt::Source['mariadb'],
  override_options => { 'mysqld' =>
                        { 'bind-address' => '0.0.0.0' }
                      },
}
