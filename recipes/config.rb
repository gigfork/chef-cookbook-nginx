include_recipe "ssl-cert"

if node['nginx']['passenger'] then
    command = Chef::ShellOut.new("passenger-config --root")
    proot = command.run_command.stdout.chomp("\n")
else
    proot = nil
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    :passenger_root => proot
  )
  notifies :reload, "service[nginx]"
end

include_recipe "nginx::no_default_site"
