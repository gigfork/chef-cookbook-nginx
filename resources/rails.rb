actions :create, :delete
 
attribute :app_name,    :kind_of => String, :name_attribute => true
attribute :site_name,   :kind_of => String, :default => ""
attribute :ssl_key,     :kind_of => String, :default => ""
attribute :ssl_cert,    :kind_of => String, :default => ""
