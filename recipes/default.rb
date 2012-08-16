#
# Cookbook Name:: nginx
# Recipe:: default
#

case node['platform']
when 'redhat','centos','scientific','amazon','oracle'
  include_recipe 'yum::epel'
end
package 'nginx'
service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action :enable
end

directory node['nginx']['dir'] do
  mode  0755
  owner "root"
  group "root"
end

directory node['nginx']['log_dir'] do
  mode   0755
  owner  node['nginx']['user']
  action :create
end

%w(sites-available sites-enabled conf.d).each do |leaf|
  directory File.join(node['nginx']['dir'], leaf) do
    mode  0755
    owner "root"
    group "root"
  end
end

%w(nxensite nxdissite).each do |nxscript|
  template "/usr/sbin/#{nxscript}" do
    source "#{nxscript}.erb"
    mode  0755
    owner "root"
    group "root"
  end
end

template "nginx.conf" do
  path     "#{node['nginx']['dir']}/nginx.conf"
  source   "nginx.conf.erb"
  mode     0644
  owner    "root"
  group    "root"
  notifies :reload, 'service[nginx]', :immediately
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action :start
end
