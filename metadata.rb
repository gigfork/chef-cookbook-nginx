maintainer        "AT&T Services, Inc"
license           ""
description       "Install nginx"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.6"

recipe "nginx", "Install nginx and put into place sites-available|sites-enabled structure"
recipe "nginx::msource", "Install nginx"

depends "build-essential", "ssl-cert"

%w{ ubuntu debian redhat centos arch }.each do |os|
  supports os
end

attribute "nginx/dir",
  :display_name => "Nginx Directory",
  :description => "Location of nginx configuration files",
  :default => "/etc/nginx"

attribute "nginx/log_dir",
  :display_name => "Nginx Log Directory",
  :description => "Location for nginx logs",
  :default => "/var/log/nginx"

attribute "nginx/user",
  :display_name => "Nginx User",
  :description => "User nginx will run as",
  :default => "www-data"

attribute "nginx/binary",
  :display_name => "Nginx Binary",
  :description => "Location of the nginx server binary",
  :default => "/usr/sbin/nginx"

attribute "nginx/worker_processes",
  :display_name => "Nginx Worker Processes",
  :description => "Number of worker processes",
  :default => "1"

attribute "nginx/worker_connections",
  :display_name => "Nginx Worker Connections",
  :description => "Number of connections per worker",
  :default => "1024"

