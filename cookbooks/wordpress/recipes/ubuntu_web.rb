log 'Instalando servidor Apache' do
    level :info 
end

package "apache2" do
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

package "php-mysql" do
    action :install
end

package "php-mysqlnd" do
    action :install
end

package "php-mysqli" do
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

service "apache2" do
    action [:enable, :start]
end