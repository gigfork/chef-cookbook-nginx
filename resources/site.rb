actions :create, :delete

attribute :fqdn,      :kind_of => String, :name_attribute => true
attribute :servers,   :kind_of => Array,   :required => true
