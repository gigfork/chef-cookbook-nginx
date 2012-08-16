#
# Cookbook Name:: nginx
# Attributes:: default

default['nginx']['version'] = "1.2.2"
default['nginx']['dir']     = "/etc/nginx"
default['nginx']['log_dir'] = "/var/log/nginx"
default['nginx']['binary']  = "/usr/sbin/nginx"
default['nginx']['pid']     = "/var/run/nginx.pid"

default['nginx']['worker_processes']   = cpu['total']
default['nginx']['worker_connections'] = 1024

case node['platform']
when "debian","ubuntu"
  default['nginx']['user']       = "www-data"
  default['nginx']['init_style'] = "runit"
when "redhat","centos","scientific","amazon","oracle","fedora"
  default['nginx']['user']       = "nginx"
  default['nginx']['init_style'] = "init"
else
  default['nginx']['user']       = "www-data"
  default['nginx']['init_style'] = "init"
end

default['nginx']['gzip']              = "on"
default['nginx']['gzip_http_version'] = "1.0"
default['nginx']['gzip_comp_level']   = "2"
default['nginx']['gzip_proxied']      = "any"
default['nginx']['gzip_types']        = [
  "text/plain",
  "text/css",
  "application/x-javascript",
  "text/xml",
  "application/xml",
  "application/xml+rss",
  "text/javascript",
  "application/javascript",
  "application/json"
]
