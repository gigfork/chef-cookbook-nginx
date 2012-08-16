#
# Cookbook Name:: nginx
# Recipe:: default
#

nginx_url = node['nginx']['source']['url'] ||
  "http://nginx.org/download/nginx-#{node['nginx']['version']}.tar.gz"

unless(node['nginx']['source']['prefix'])
  node.set['nginx']['source']['prefix'] = "/opt/nginx-#{node['nginx']['version']}"
end
unless(node['nginx']['source']['conf_path'])
  node.set['nginx']['source']['conf_path'] = "#{node['nginx']['dir']}/nginx.conf"
end
unless(node['nginx']['source']['default_configure_flags'])
  node.set['nginx']['source']['default_configure_flags'] = [
    "--prefix=#{node['nginx']['source']['prefix']}",
    "--conf-path=#{node['nginx']['dir']}/nginx.conf",
    "--with-http_ssl_module",
    "--with-http_stub_status_module",
    "--with-http_realip_module"
  ]
end

node.set['nginx']['binary']         = "#{node['nginx']['source']['prefix']}/sbin/nginx"
node.set['nginx']['daemon_disable'] = true

include_recipe "build-essential"

src_filepath = "#{Chef::Config['file_cache_path'] || '/tmp'}/nginx-#{node['nginx']['version']}.tar.gz"
packages     = value_for_platform(
    [ "centos","redhat","fedora"] => {'default' => ['pcre-devel', 'openssl-devel']},
      "default" => ['libpcre3', 'libpcre3-dev', 'libssl-dev']
  )

packages.each do |devpkg|
  package devpkg
end

remote_file nginx_url do
  source nginx_url
  path   src_filepath
  backup false
end

user node['nginx']['user'] do
  system true
  shell  "/bin/false"
  home   "/var/www"
end

node.run_state['nginx_force_recompile'] = false
node.run_state['nginx_configure_flags'] = 
  node['nginx']['source']['default_configure_flags'] | node['nginx']['configure_flags']


configure_flags       = node.run_state['nginx_configure_flags']
nginx_force_recompile = node.run_state['nginx_force_recompile']

bash "compile_nginx_source" do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    tar zxf #{::File.basename(src_filepath)} -C #{::File.dirname(src_filepath)}
    cd nginx-#{node['nginx']['version']} && ./configure #{node.run_state['nginx_configure_flags'].join(" ")}
    make && make install
    rm -f #{node['nginx']['dir']}/nginx.conf
  EOH

  not_if do
    nginx_force_recompile == false &&
      node.automatic_attrs['nginx']['version'] == node['nginx']['version'] &&
      node.automatic_attrs['nginx']['configure_arguments'].sort == configure_flags.sort
  end
end

node.run_state.delete(:nginx_configure_flags)
node.run_state.delete(:nginx_force_recompile)

node.set['nginx']['daemon_disable'] = false

template "/etc/init.d/nginx" do
  source "nginx.init.erb"
  mode   0755
  owner  "root"
  group  "root"
  variables(
    :working_dir => node['nginx']['source']['prefix'],
    :src_binary => node['nginx']['binary'],
    :nginx_dir => node['nginx']['dir'],
    :log_dir => node['nginx']['log_dir'],
    :pid => node['nginx']['pid']
  )
end

template "/etc/sysconfig/nginx" do
  source "nginx.sysconfig.erb"
  mode   0644
  owner  "root"
  group  "root"
end

service "nginx" do
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
    mode   0755
    owner  "root"
    group  "root"
  end
end

template "nginx.conf" do
  path "#{node['nginx']['dir']}/nginx.conf"
  source   "nginx.conf.erb"
  mode     0644
  owner    "root"
  group    "root"
  notifies :reload, 'service[nginx]', :immediately
end

template "#{node['nginx']['dir']}/sites-available/default" do
  source "default-site.erb"
  mode   0644
  owner  "root"
  group  "root"
end

cookbook_file "#{node['nginx']['dir']}/mime.types" do
  source   "mime.types"
  mode     0644
  owner    "root"
  group    "root"
  notifies :reload, 'service[nginx]', :immediately
end

service "nginx" do
  action :start
end
