#
# Cookbook Name: nginx
# Recipe:: site
include_recipe "nginx::default"

if node['nginx']['site']['snakeoil'] then
  case node[:platform]
  when "ubuntu", "debian"
    package "ssl-cert" do
      action :install
    end
  end
  
  if not File.exists? "/etc/ssl/certs/ssl-cert-snakeoil.pem" then
    script "install_something" do
      interpreter "bash"
      user "root"
      code <<-EOH
      /usr/sbin/make-ssl-cert generate-default-snakeoil
      EOH
    end
  end
end


template "site.conf" do
  path          "#{node['nginx']['dir']}/conf.d/#{node['nginx']['site']['sitename']}.conf" 
  mode          0644
  owner         "root"
  group         "root"
  notifies      :reload, "service[nginx]", :immediately
end
