vagrant-php-fpm
===============

A basic vagrant machine designed to simulate our on campus web
hosting.

## Enabling Wordpress support

To enable support for wordpress, uncomment the line in
puppet/manifests/site.pp that reads 
`apache_def => { 'fallbackresource' => '/index.php' },` by removing
the # at the start of the line.
