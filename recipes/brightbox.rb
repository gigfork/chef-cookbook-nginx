#
# Cookbook Name:: nginx
# Recipe:: brightbox

Chef::Log.info "Adding the brightbox passenger-nginx  ppa repository"
apt_repository "brightbox-passenger-nginx" do
  uri "http://ppa.launchpad.net/brightbox/passenger-nginx/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C3173AA6"
end


Chef::Log.info "Installing nginx...."
package "nginx-full" do
  action :install
end



template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    :passenger_root => "#{node['languages']['ruby']['gems_dir']}/gems/passenger-#{node['nginx']['passenger']['version']}"
  )
  notifies :reload, "service[nginx]"
end

include_recipe "nginx::service"
include_recipe "nginx::sites" if not node['nginx']['sites'].nil?
