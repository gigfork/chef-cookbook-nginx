#
# Cookbook Name:: nginx
# Recipe:: source
include_recipe "ssl-cert"

version = node['nginx']['version']
workdir = "#{Chef::Config['file_cache_path']}/build_nginx" || '/tmp/build_nginx'
Chef::Log.info "Build directory set to #{workdir}"

version_str = `dpkg -l nginx | awk '/ii/{print $3}'`
install     = false

if not version_str.include? node['nginx']['version'] or
  node['nginx']['force'] then
  Chef::Log.info "cleaning up old working directory"
  install = true
  # we clean that up first if they exist
  bash "remove-old" do
    user "root"
    code <<-EOF
    rm -rf #{workdir}
    apt-get purge nginx nginx-full nginx-common -y
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
  Chef::Log.info "installing source package nginx=#{node['nginx']['version']}"
  user "root"
  cwd  Chef::Config['file_cache_path']
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

if node['nginx']['passenger']['enable'] then
  gem_package "passenger" do
    action :install
    ignore_failure false
  end
  proot = "#{node['languages']['ruby']['gems_dir']}/gems/"
  proot << "passenger-#{node['nginx']['passenger']['version']}" 

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
  Chef::Log.info "building Nginx..."

  user "root"
  cwd "#{workdir}/nginx-#{node['nginx']['version']}"
  code <<-EOH
  dpkg-buildpackage -us -uc
  # we did need to call this twice or the build would fail, seems to not be 
  # required anymore
  # dpkg-buildpackage -us -uc
  EOH
  only_if {install}
end

if node['nginx']['passenger']['enable'] then
  bash "install-nginx" do
    Chef::Log.info "Installing Nginx from source package with passenger support..."

    user "root"
    cwd workdir
    code <<-EOF
    dpkg -i nginx-common_#{node['nginx']['version']}-?ubuntu0ppa?\~precise_all.deb
    dpkg -i nginx-full_#{node['nginx']['version']}-?ubuntu0ppa?\~precise_amd64.deb
    dpkg -i nginx_#{node['nginx']['version']}-?ubuntu0ppa?\~precise_all.deb
    cd $(passenger-config --root)
    rake nginx RELEASE=yes
    EOF
    only_if {install}
  end
else
  bash "install-nginx" do
    Chef::Log.info "Installing Nginx from source package..."

    user "root"
    cwd workdir
    code <<-EOF
    dpkg -i nginx-common_#{node['nginx']['version']}-?ubuntu0ppa?\~precise_all.deb
    dpkg -i nginx-full_#{node['nginx']['version']}-?ubuntu0ppa?\~precise_amd64.deb
    dpkg -i nginx_#{node['nginx']['version']}-?ubuntu0ppa?\~precise_all.deb
    EOF
    only_if {install}
  end

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

include_recipe "nginx::service"
include_recipe "nginx::sites" if not node['nginx']['sites'].nil?
