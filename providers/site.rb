action :create do
  template "/etc/nginx/conf.d/#{new_resource.name}.conf" do
    source   "site.conf.erb"
    cookbook "nginx"
    mode 0644
    owner "root"
    group "root"
    variables :fqdn => new_resource.name, 
              :servers => new_resource.servers,
              :upstreams => new_resource.upstreams
    notifies :reload, "service[nginx]", :immediately
  end
end

action :delete do
  file "/etc/nginx/conf.d/#{new_resource.name}.conf" do
    action :delete
  end
end
