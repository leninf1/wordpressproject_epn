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