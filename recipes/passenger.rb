#
# Cookbook Name:: nginx
# Recipe:: passenger
#
include_recipe "passenger"

random = rand(10000)

root = "/tmp/root-passenger-#{random}/pcre"
version = node['nginx']['passenger']['version']
pcre = node['nginx']['passenger']['pcre']
ruby-version = node['nginx']['passenger']['pcre']

node.run_state['nginx']['source']['pcre'] =  root

bash "fetch-pcre-source" do
  code <<-EOF
  wget -O #{root}.tar.gz \
      http://downloads.sourceforge.net/project/pcre/pcre/#{pcre}/pcre-#{pcre}.tar.gz
  cd /tmp/root-passenger-#{random}/
  tar xzvf pcre.tar.gz
  EOF
end

node.run_state['nginx_configure_flags'].push("--with-pcre='#{root}'")
node.run_state['nginx_configure_flags'].push("--add-module=/var/lib/gems/#{ruby-version}/gems/passenger-#{version}/ext/nginx")
