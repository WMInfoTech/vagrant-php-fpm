define php_web::vhost (
  $domain         = $name,
  $webroot        = undef,
  $ensure         = 'present',
  $user           = $::php_web::params::vhost_user,
  $group          = $::php_web::params::vhost_user,
  $uid            = $::php_web::params::uid,
  $gid            = $::php_web::params::uid,
  $manage_user    = $::php_web::params::manage_vhost_user,
  $upload_limit   = '5M',
  $show_errors    = false,
  $aliases        = [],
  $apache_def     = {},
  $php_fpm_def    = {},
) {

  $webserver = getparam(Class['php_web'], 'webserver')
  $vhost_root = getparam(Class['php_web'], 'vhost_root')
  $php_session_handler = getparam(Class['php_web'], 'session_handler')
  $php_session_path = getparam(Class['php_web'], 'session_path')

  if !$uid or !$gid { # If the user is being managed we need to know UID/GID
    fail('UID/GID is required')
  }

  if !defined(User[$user]) {
    user { $user:
      ensure   => $ensure,
      uid      => $uid,
      gid      => $gid,
      home     => $webroot_real,
      shell    => $::php_web::params::user_shell,
      password => '!',
    }
  }

  if !defined(Group[$group]) {
    group { $group:
      ensure => $ensure,
      gid    => $gid,
    }
  }

  if !$webroot {
    $webroot_base = "${vhost_root}/${domain}"
    $webroot_real = "${webroot_base}/public_html"
  } else {
    $webroot_base = $webroot
    $webroot_real = "${webroot}/public_html"
  }
  
  if !defined(File[$webroot_real]) {
    file { $webroot_base:
      ensure => 'directory',
      mode   => '2764',
      owner  => $user,
      group  => $group,
    }

    # Running this as an exec with user and group set ensure that the dependent file
    # resource actually set permissions as expected.
    exec { "make_${webroot_real}":
      creates => $webroot_real,
      command => "mkdir -p ${webroot_real}",
      path    => ['/bin', '/usr/bin'],
      user    => $user,
      group   => $group,
      require => File[$webroot_base],
    }
  }

  if $webserver == 'apache' {
    $vhost = {
      'servername'      => $domain,
      'serveraliases'   => $aliases,
      'docroot'         => $webroot_real,
      'port'            => 80,
      'ssl'             => false,
      'fastcgi_server'  => "/usr/lib/cgi-bin/php5.fastcgi.${domain}",
      'fastcgi_socket'  => "/var/run/${domain}.sock",
      'custom_fragment' =>
        "
        AddHandler php5-fcgi .php
        Action php5-fcgi /php5.fastcgi virtual
        Alias /php5.fastcgi /usr/lib/cgi-bin/php5.fastcgi.${domain}

        ",
    }

    # If there's a custom_fragment in the declaration then
    # it should be merge with what we already have otherwise things
    # will break.
    if is_string($apache_def['custom_fragment']) {
      $vhost_override = { 
      'custom_fragment' => 
        "${vhost['custom_fragment']} ${apache_def['custom_fragment']}",
      }
      $upper_vhost = deep_merge($vhost, $vhost_override)
    } else {
      $upper_vhost = $vhost
    }
    # Merge the definition with what we have here
    # What we already have takes precedence since it's required
    # for things to work.

    # Until the future (4.x) parser is widely supported we need to do this 
    # array to hash hack so that the hash keys can be defined by variables
    $apache_vhost_data = deep_merge($vhost, $upper_vhost)
    $apache_vhost = hash([ $domain, $apache_vhost_data ])

    # Create the vhost resource
    create_resources('apache::vhost', $apache_vhost)
  } 

  # nginx stuff goes here

  $php_display_errors = $show_errors ? {
    true  => 'on',
    false => 'off',
  }

  $php_fpm = hash( [
    $domain,  {
      'user'            => $user,
      'group'           => $group,
      'listen'          => "/var/run/${domain}.sock",
      'error_log'       => "${webroot_base}/php.error.log",
      'php_admin_value' =>
        {
          'disable_functions'   => 'phpinfo,eval,exec,shell_exec',
          'date.timezone'       => 'America/New_York',
          'upload_max_filesize' => $upload_limit,
          'post_max_size'       => $upload_limit,
          'display_errors'      => $php_display_errors,
        },
      'php_value'       =>
        {
          'session.save_handler' => $php_session_handler,
          'session.save_path'    => "\"${php_session_path}\"",
        }
    }])

  create_resources('php::fpm::conf', $php_fpm)
}