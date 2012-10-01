#
# Cookbook Name:: nginx
# Recipe:: rails-site

if node['nginx']['rails']['ssl_cert'].include? "snakeoil" then
  include_recipe "ssl-cert"
end


template "/etc/nginx/conf.d/rails-site.conf" do
  source "rails-site.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
      :site_name => node['nginx']['rails']['sitename'],
      :app_name  => node['nginx']['rails']['app_name'],
      :ssl_cert  => node['nginx']['rails']['ssl_cert'],
      :ssl_key   => node['nginx']['rails']['ssl_key']
  )
  notifies :reload, "service[nginx]", :immediately

end
