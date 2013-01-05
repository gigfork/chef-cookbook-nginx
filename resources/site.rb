actions :create, :delete

attribute :fqdn,      :kind_of => String, :name_attribute => true
attribute :servers,   :kind_of => Array,  :default => Array.new
attribute :upstreams, :kind_of => Hash,  :default => Hash.new 
