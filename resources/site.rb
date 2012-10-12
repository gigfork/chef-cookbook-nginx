actions :create, :delete

attribute :fqdn,      :kind_of => String, :name_attribute => true
attribute :ssl_key,   :kind_of => String, :default => ""
attribute :ssl_cert,  :kind_of => String, :default => ""
attribute :root,      :kind_of => String, :default => "/var/www/apps"
attribute :cookbook,  :kind_of => String, :default => "nginx"
attribute :source,    :kind_of => String, :default => "site.conf.erb"
