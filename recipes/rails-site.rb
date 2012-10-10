#
# Cookbook Name:: nginx
# Recipe:: rails-site

if node['nginx']['rails']['ssl_cert'].include? "snakeoil" then
  include_recipe "ssl-cert"
end


rails_site node['nginx']['rails']['site_name'] do
      app_name  node['nginx']['rails']['app_name'],
      ssl_cert  node['nginx']['rails']['ssl_cert'],
      ssl_key   node['nginx']['rails']['ssl_key']
end
