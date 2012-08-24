#
# Cookbook Name: nginx
# Recipe:: site
include_recipe "nginx::default"

template "site.conf" do
  path          "#{node['nginx']['dir']}/conf.d/<%= node['nginx']['site']['sitename'] %>.conf" 
  port_based    node['nginx']['site']['port_based']
  server_ports  node['nginx']['site']['server_ports']
  sitename      node['nginx']['site']['sitename']
  ssl_cert      node['nginx']['site']['ssl_cert']
  ssl_key       node['nginx']['site']['ssl_key']
  mode          0644
  owner         "root"
  group         "root"
  notifies      :reload, "service[nginx]", :immediately
end
