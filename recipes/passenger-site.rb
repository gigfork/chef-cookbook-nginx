#
# Cookbook Name:: nginx
# Recipe:: passenger-site

command = Chef::ShellOut.new("passenger-config --root")

if node['nginx']['passenger']['ssl_cert'].include? "snakeoil" then
  include_recipe "ssl-cert"
end


nginx_passenger "passenger-site" do
    site_name  node['nginx']['passenger']['site_name']
    app_name   node['nginx']['passenger']['app_name']
    ssl_cert   node['nginx']['passenger']['ssl_cert']
    ssl_key    node['nginx']['passenger']['ssl_key']
    rails_env  node['nginx']['passenger']['rails_env']
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    :passenger_root => command.run_command.stdout.chomp("\n")
  )
end
