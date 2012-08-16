Description
===========

Copyright 2012, AT&T Services, Inc.
All rights reserved.

Installs nginx with site specific configuration structure.

Target OS's: Ubuntu, Debian, Redhat, Centos

Core items borrowed from the original nginx recipe from Opscode https://github.com/opscode-cookbooks/nginx

Original Authors:
  Joshua Timberman (<joshua@opscode.com>)
  Adam Jacob (<adam@opscode.com>)
  AJ Christensen (<aj@opscode.com>)
  Jamie Winsor (<jamie@vialstudios.com>)


Requirements
============

* build-essential

Attributes
==========

Directories: 

* `node['nginx']['dir']`
* `node['nginx']['log_dir']`
* `node['nginx']['pid']`

nginx.conf values:

* `node['nginx']['user']`
* `node['nginx']['binary']`
* `node['nginx']['worker_processes']`
* `node['nginx']['worker_connections']`

module configuration:

* `node['nginx']['realip']['header']` - "X-Forwarded-For" or "X-Real-IP"
* `node['nginx']['realip']['addresses']` - `http_realip` IP address

Recipes
=======

default.rb - Use the default recipe to install nginx via a system package.
source.rb - Use the source recipe to install nginx from a source tarball

Source build will enable the following modules:

* gzip, realip, ssl and stub_status
