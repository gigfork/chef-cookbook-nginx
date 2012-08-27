#
# Cookbook Name: nginx
# Attributes:: site
#

default['nginx']['site']['port_based'] = false
default['nginx']['site']['server_ports'] = (5000..5005)
default['nginx']['site']['sitename'] = "railsapp"
default['nginx']['site']['ssl_cert'] = "/etc/ssl/certs/ssl-cert-snakeoil.pem"
default['nginx']['site']['ssl_key'] = "/etc/ssl/private/ssl-cert-snakeoil.key"
