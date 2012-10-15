action :create do
  template "/etc/nginx/conf.d/#{new_resource.name}.conf" do
    source   new_resource.source
    cookbook new_resource.cookbook
    mode 0644
    owner "root"
    group "root"
    variables :fqdn      => new_resource.name,
              :ssl_cert  => new_resource.ssl_cert,
              :ssl_key   => new_resource.ssl_key,
              :root      => new_resource.root
    notifies :reload, resources(:service => "nginx"), :immediately
  end
end

action :delete do
  file "/etc/nginx/conf.d/#{new_resource.name}" do
    action :delete
    notifies :reload, resources(:service => "nginx"), :immediately
  end
end
