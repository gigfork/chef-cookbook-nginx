#
# Cookbook Name:: nginx
# Attributes:: source
#

set['nginx']['source']['prefix']    = "/opt/nginx-#{node['nginx']['version']}"
set['nginx']['source']['conf_path'] = "#{node['nginx']['dir']}/nginx.conf"
set['nginx']['source']['default_configure_flags'] = [
  "--prefix=#{node['nginx']['source']['prefix']}",
  "--conf-path=#{node['nginx']['dir']}/nginx.conf"
]

default['nginx']['configure_flags'] = Array.new
default['nginx']['source']['url']   = "http://nginx.org/download/nginx-#{node['nginx']['version']}.tar.gz"
