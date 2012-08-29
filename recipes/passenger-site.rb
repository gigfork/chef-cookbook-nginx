#
# Cookbook Name:: nginx
# Recipe:: passenger-site

template "/etc/nginx/conf.d/passenger-site.conf" do
  source "passenger-site.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
      :site_name => node['nginx']['passenger']['sitename'],
      :app_name => node['nginx']['passenger']['app_name'],
      :ssl_cert => node['nginx']['passenger']['ssl_cert'],
      :ssl_key => node['nginx']['passenger']['ssl_key']
  )
  notifies :reload, "service[nginx]", :immediately

end
