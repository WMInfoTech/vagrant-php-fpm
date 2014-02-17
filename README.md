vagrant-phpweb
==============

A vagrant machine designed to create a basic LAMP stack, but using
PHP-FPM with fastcgi instead of mod_php.

## Use

To start the machine, navigate in a terminal to the root of this repository and run `vagrant up`.

After a few minutes you'll have development server that very closely resembles
the server your site will run on in production.

The folder `webroot/` is the equivalent to the folder you'll have access to when
uploading content to the production web server.  Files that don't need to directly
accessed by the public should be kept in `webroot/`, while public content that should
be served by the web server should be kept in `webroot/public_html`.

The VM also includes a MySQL/MariaDB server for database development.  The database
can be connected to using the same name that will be used in production of `webdb.wm.edu`.
There is no root password for the database server.

## Caveats

Database storage is ephemeral and will be lost when you run `vagrant destroy`.  To save
database content it should be dump using `mysqlbackup`.  Only the `/vagrant` and 
`/var/www/vhosts/vagrant.localhost` folders will persist after the vagrant machine is 
destroyed.

To pause the machine without destroying it, use the `vagrant suspsend` and `vagrant resume`
commands.
