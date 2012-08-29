#
# Cookbook Name:: nginx
# Attributes:: default


default['nginx']['version'] = "1.2.3"
default['nginx']['ppa'] = "ppa:nginx/stable"
default['nginx']['force'] = false
default['nginx']['config']['default'] = false
default['nginx']['passenger-site'] = true
default['nginx']['passenger']['sitename'] = "rails_site"
default['nginx']['passenger']['app_name'] = "rails_app"
default['nginx']['passenger']['ssl'] = true
default['nginx']['passenger']['ssl_cert'] = "/etc/ssl/certs/ssl-cert-snakeoil.pem"
default['nginx']['passenger']['ssl_key'] = "/etc/ssl/private/ssl-cert-snakeoil.key"
                                            
