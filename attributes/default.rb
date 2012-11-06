#
# Cookbook Name:: nginx
# Attributes:: default

default['nginx']['version'] = "1.2.4"
default['nginx']['ppa'] = "ppa:nginx/stable"
default['nginx']['force'] = false
default['nginx']['config']['default'] = false
