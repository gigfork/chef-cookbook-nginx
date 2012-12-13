#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2012, AT&T Foundry
#
# All rights reserved 
include_recipe "nginx::service"

package "nginx" do
    action :upgrade
    notifies :reload, "service[nginx]"
end

include_recipe "nginx::config"
include_recipe "nginx::sites" if node['nginx']['sites']
