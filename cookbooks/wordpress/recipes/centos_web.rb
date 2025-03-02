log 'Instalando servidor Apache' do
    level :info 
end

package "httpd" do
    action :install
end

log 'Instalando php' do
    level :info 
end

package "php" do
    action :install
end

log 'Provisionando librerías php' do
    level :info 
end

package "php-mysqlnd" do
    action :install
end

package "php-json" do
  action :install
end

log 'Instalado compresor de archivos' do
    level :info 
end

package "unzip" do
    action :install
end

log 'Instalando curl' do
    level :info 
end

package "curl" do
    action :install
end

log 'Reemplazando archivo info.php' do
    level :info 
end

file "/var/www/html/info.php" do
    content "<?php\nphpinfo();\n?>" 
end

log 'habilitando conexion a red a Apache' do
    level :info 
end

selinux_boolean 'httpd_can_network_connect' do
    value true
    action :set
end

selinux_boolean 'httpd_can_network_connect_db' do
    value true
    action :set
end

log 'Habilitando reglas de firewall para conexiones entrantes' do
    level :info 
end

execute 'firewall-cmd --zone=public --add-port=8080/tcp --permanent' do
    action :run
end

execute 'firewall-cmd --zone=public --add-port=80/tcp --permanent' do
    action :run
end

log 'Reiniciando Firewall' do
    level :info 
end

execute 'firewall-cmd --reload' do
    action :run
end

log 'Reiniciando Apache' do
    level :info 
end

service "httpd" do
    action [:enable, :start]
end