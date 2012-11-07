actions :create, :delete

attribute :site_name, :kind_of => String, :default => ""
attribute :ssl_key,   :kind_of => String, :default => ""
attribute :ssl_cert,  :kind_of => String, :default => ""
attribute :rails_env, :kind_of => String, :default => "development"
attribute :docroot,   :kind_of => String, :required => true
