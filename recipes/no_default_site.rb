#
# Cookbook Name:: nginx
# Recipe:: no_default_site
#
# Copyright 2012, AT&T Foundry
#
# All rights reserved 

Chef::Log.info "Deleting default site file..."
file "/etc/nginx/sites-enabled/default" do
  action :delete
end

file "/etc/nginx/sites-available/default" do
  action :delete
  notifies :reload, "service[nginx]"
end
