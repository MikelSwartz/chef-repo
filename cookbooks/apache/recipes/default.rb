# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'socket'

myHostName = Socket.gethostname
localIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
publicIP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`

apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

package 'apache2'

file '/var/www/html/fuse.html' do
  content "<html>
  <body>
    <h1>Mike Swartz</h1>
    <p>Hostname: #{myHostName}</p>
    <p>Local IP: #{localIP}</p>
    <p>Public IP: #{publicIP}</p>
    <a href=\"chef-solo.log\" download>chef-solo log file</a>
  </body>
</html>"
end

execute "dir.conf" do
  command "sed -i 's/DirectoryIndex .*/DirectoryIndex fuse.html/g' /etc/apache2/mods-enabled/dir.conf"
  action :run
end

service 'apache2' do
  supports status: true
  action [:enable, :restart]
end

