log 'Iniciando la configuración de MySQL en CentOS' do
    level :info 
end

if node != nil && node['config'] != nil
    log 'Configuración encontrada: Iniciando la configuración de MySQL con varibles globales' do
        level :info 
    end
    db_user = node['config']['db_user'] || "wordpress"
    db_pswd = node['config']['db_pswd'] || "wordpress"
    wp_ip   = node['config']['wp_ip'] || "127.0.0.1"
else
    log 'Configuración no encontrada: Iniciando la configuración de MySQL con varibles por defecto' do
        level :info 
    end
    db_user = "wordpress"
    db_pswd = "wordpress"
    wp_ip   = "127.0.0.1"
end

# Instalar MySQL server
log 'Iniciando la instalacion de mysql-server' do
    level :info 
end

package 'mysql-server' do
    action :install
end

# Habilitar el servicio MySQL
log 'Habilitando servicio de mysql-server' do
    level :info 
end

service "mysqld" do
    action [:enable, :start]
end

log 'Instalacion de mysql-server terminada' do
    level :info 
end

# Ejecutar comando para crear la base de datos
log 'Iniciando base de datos de wordpress' do
    level :info 
end

execute 'create_mysql_database' do
    command 'mysql -e "CREATE DATABASE wordpress;"'
    action :run
    not_if 'mysql -e "SHOW DATABASES;" | grep wordpress'
end

# Ejecutar comando para crear el usuario y otorgar permisos
execute 'create_mysql_user' do
    command "mysql -e \"CREATE USER '#{db_user}'@'#{wp_ip}' IDENTIFIED BY '#{db_pswd}'; GRANT ALL PRIVILEGES ON wordpress.* TO '#{db_user}'@'#{wp_ip}'; FLUSH PRIVILEGES;\""
    action :run
    not_if "mysql -e \"SELECT User, Host FROM mysql.user WHERE User = '#{db_user}' AND Host = '#{wp_ip}'\" | grep #{db_user}"
end

log 'Iniciando configuración de firewall de wordpress' do
    level :info 
end

execute 'firewall-cmd --zone=public --add-port=3306/tcp --permanent' do
    action :run
end

execute 'firewall-cmd --reload' do
    action :run
end