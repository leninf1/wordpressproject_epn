log 'Asignando permisos a directorio /opt/ a usuario root' do
    level :info 
end

directory "/opt/" do
    owner "root"
    group "root"
end

log 'Descargando Wordpress' do
    level :info 
end

execute "get wordpress" do
    command "curl -o /tmp/wordpress.zip https://wordpress.org/latest.zip"
    action :run
    not_if { ::File.exist?('/tmp/wordpress.zip') }
end

execute "extract_wordpress" do
    command "unzip -q /tmp/wordpress.zip -d /opt/"
    action :run
    notifies :run, 'execute[set_wordpress_permissions]', :immediately
    not_if { ::File.exist?('/opt/wordpress') }
end

log 'Asignando permisos a carpeta de Wordpress' do
    level :info 
end

execute "set_wordpress_permissions" do
    command "chmod -R 755 /opt/wordpress/"
    action :nothing
end

log 'Reemplazando archivos de Configuracion de Wordpress con las plantillas elaboradas' do
    level :info 
end

template '/opt/wordpress/wp-config.php' do
    source 'wp-config.php.erb'
    mode '0644'
    not_if { ::File.exist?('/opt/wordpress/wp-config.php') }
end

template '/etc/httpd/conf.d/wordpress.conf' do
    source 'wordpress.conf.erb'
    not_if { ::File.exist?('/etc/httpd/conf.d/wordpress.conf') }
end

log 'Reiniciando servidor Apache' do
    level :info 
end

service "httpd" do
    action :restart
end