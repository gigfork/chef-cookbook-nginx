#
# Cookbook Name:: nginx
# Attributes:: default

default['nginx']['version'] = "1.2.4"
default['nginx']['ppa'] = "ppa:nginx/stable"
default['nginx']['force'] = nil
default['nginx']['sites'] = nil

## passenger 
default['nginx']['passenger']['enable'] = nil
default['nginx']['passenger']['version'] = "3.0.18"
