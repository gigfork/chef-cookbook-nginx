action :create do
  template "/etc/nginx/conf.d/#{new_resource.name}.conf" do
    source "passenger-site.conf.erb"
    mode 0644
    owner "root"
    group "root"
    variables :site_name => new_resource.name,
              :app_name  => new_resource.app_name,
              :ssl_cert  => new_resource.ssl_cert,
              :ssl_key   => new_resource.ssl_key,
              :rails_env => new_resource.rails_env
    notifies :reload, "service[nginx']", :immediately
  end
end

action :delete do
  file "/etc/nginx/conf.d/#{new_resource.name}" do
    action :delete
    notifies :reload, "service[nginx']", :immediately
  end
end
