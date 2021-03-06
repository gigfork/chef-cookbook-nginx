#
# Cookbook Name:: nginx
# Recipe:: brightbox

Chef::Log.info "Adding the brightbox passenger-nginx  ppa repository"
apt_repository "brightbox-ruby-ng" do
  uri "http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C3173AA6"
end

Chef::Log.info "Installing passenger-common1.9.1...."
package "passenger-common1.9.1" do
  action :install
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
    :passenger_root => "/usr/lib/phusion-passenger"
  )
  notifies :reload, "service[nginx]"
end

include_recipe "nginx::service"
include_recipe "nginx::sites" if not node['nginx']['sites'].nil?
