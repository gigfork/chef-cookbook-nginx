#
# Cookbook Name: nginx
# Recipe:: site
include_recipe "nginx::default"

template "site.conf" do
  path          "#{node['nginx']['dir']}/conf.d/<%= node['nginx']['site']['sitename'] %>.conf" 
  mode          0644
  owner         "root"
  group         "root"
  notifies      :reload, "service[nginx]", :immediately
end
