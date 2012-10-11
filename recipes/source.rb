#
# Cookbook Name:: nginx
# Recipe:: source

include_recipe "build-essential"

version   = node['nginx']['version']
workdir = "#{Chef::Config['file_cache_path']}/build_nginx" || '/tmp/build_nginx'
Chef::Log.info "Build directory set to #{workdir}"

version_str = `dpkg -l nginx | awk '/ii/{print $3}'`
install = false

if not version_str.include? node['nginx']['version'] or
  node['nginx']['force'] then
  install = true
  # we clean that up first if they exist
  bash "remove-old" do
    user "root"
    code <<-EOF
    rm -rf #{workdir}
    dpkg -r "*nginx*" 
    EOF
  end
end

if not install
  Chef::Log.info "Nginx Install Current....skipping build"
elsif node['nginx']['force']
  Chef::Log.info "Nginx force build option is set...building"
else
  Chef::Log.info "Installing Nginx..."
end

# Install build dependencies
bash "build-dep" do
  user "root"
  code <<-EOF
  mkdir -p #{workdir}
  cd #{workdir}
  add-apt-repository #{node['nginx']['ppa']} -y
  apt-get update
  apt-get build-dep nginx -y
  apt-get install fakeroot -y
  apt-get source nginx='#{node['nginx']['version']}' -y
  EOF
  only_if {install}
end

if node['nginx']['passenger'] then
  gem_package "passenger" do
    action :nothing
    ignore_failure false
  end.run_action(:install)

  ruby_block "add-passenger-module" do
    block do
      src_dir = "#{workdir}/nginx-#{node['nginx']['version']}" 
      text = ::File.read("#{src_dir}/debian/rules")
      
      # only add module line if needed. apt-get will not overwrite an existing
      # source download and files if they already exist resulting in multiple 
      # patches across runs 
      if not text.include? "passenger" then
        proot = `passenger-config --root`.chomp("\n")
        pmodule = "--add-module=#{proot}/ext/nginx"
        ::File.open("#{src_dir}/debian/rules", "w") {|file|
          file.puts text.gsub("$(CONFIGURE_OPTS)", "#{pmodule} \\\n$(CONFIGURE_OPTS)") 
        }
      end
    end
    only_if {install}
  end
end

bash "build-nginx" do 
  user "root"
  cwd "#{workdir}/nginx-#{node['nginx']['version']}"
  code <<-EOH
  dpkg-buildpackage -us -uc
  dpkg-buildpackage -us -uc
  EOH
  only_if {install}
end

bash "install-nginx" do
  user "root"
  cwd workdir
  code <<-EOF
  dpkg -i nginx-common_#{node['nginx']['version']}-0ubuntu0ppa3~precise_all.deb
  dpkg -i nginx-full_#{node['nginx']['version']}-0ubuntu0ppa3~precise_amd64.deb
  dpkg -i nginx_#{node['nginx']['version']}-0ubuntu0ppa3~precise_all.deb
  cd $(passenger-config --root)
  rake nginx RELEASE=yes
  EOF
  only_if {install}
end

ruby_block "post-install" do
  block do
    if not node['nginx']['config']['default'] then
      ::File.delete("/etc/nginx/sites-enabled/default")
    end
  end
  only_if {install}
end

service "nginx" do
  action :start
  supports :start => true, :stop => true, :restart => true, :reload => true, :status => true
end

include_recipe "nginx::config"
