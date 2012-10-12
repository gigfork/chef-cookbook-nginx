service "nginx" do
  supports  :restart => true, :reload => true, :status => true
  action    [ :enable, :start ]
end
