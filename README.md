vagrant-phpweb
==============

A [vagrant](http://www.vagrantup.com) machine designed to create a basic LAMP stack, but using
PHP-FPM with fastcgi instead of mod_php.  The default box uses [VirtualBox](https://www.virtualbox.org/).

## Use

To start the machine, navigate in a terminal to the root of this repository and run `vagrant up`.

After a few minutes you'll have development server that very closely resembles
the server your site will run on in production.  Unless there's a port collision,
the webserver's default port of 80 will be accessible at [http://localhost:8080](http://localhost:8080).

The folder `webroot/` is the equivalent to the folder you'll have access to when
uploading content to the production web server.  Files that don't need to directly
accessed by the public should be kept in `webroot/`, while public content that should
be served by the web server should be kept in `webroot/public_html`.

The VM also includes a MySQL/MariaDB server for database development.  The database
can be connected to using the same name that will be used in production of `mdbc1.wm.edu`.
There is no root password for the database server.

### Wordpress

If you're trying to run a wordpress site in the machine, and don't want to edit the
apache configuration by hand (and don't like .htaccess files), uncomment the lines
```puppet
apache_def => {
  fallbackresource => '/index.php',
}
```
in `puppet/manifests/site.pp` in the `php_web::vhost` section.

If you already have a running VM when you do this, run the `vagrant provision` command
to update the machine.

## Caveats

Database storage is ephemeral and will be lost when you run `vagrant destroy`.  To save
database content it should be dump using `mysqlbackup`.  Only the `/vagrant` and
`/var/www/vhosts/vagrant.localhost` folders will persist after the vagrant machine is
destroyed.

To pause the machine without destroying it, use the `vagrant suspsend` and `vagrant resume` commands.
