#
# Cookbook:: wordpress
# Recipe:: default
#
# Copyright:: 2025, The Authors, All Rights Reserved.

log 'Recuperando IP de base de datos' do
    level :info 
end
if node != nil && node['config'] != nil
    log 'Configuracion de IP encontrada' do
        level :info 
    end
    db_ip = node['config']['db_ip'] || "127.0.0.1"
else
    log 'Configuracion de IP NO encontrada; estableciendo IP por defecto' do
        level :info 
    end
    db_ip = "127.0.0.1"
end

log 'Recuperando IP de base de datos' do
    level :info 
end


log 'Agregando identificador de URL a archivo host' do
    level :info 
end

execute "add host" do
    command "echo '#{db_ip}       db.epnewman.edu.pe' >> /etc/hosts"
    action :run
end


log 'Iniciando instalacion de Servidor WEB y aprovisionamiento de wordpress' do
    level :info 
end
case node['platform_family']
when 'debian', 'ubuntu'
    execute "update" do
        command "apt update -y && apt upgrade -y"
        action :run
    end
    include_recipe 'wordpress::ubuntu_web'    # Instalamos el servidor web
    include_recipe 'wordpress::ubuntu_wp'     # Instalamos wordpress
when 'rhel', 'fedora'
    execute "update" do
        command "sudo dnf update -y && sudo dnf upgrade -y"
        action :run
    end
    include_recipe 'wordpress::centos_web'    # Instalamos el servidor web
    include_recipe 'wordpress::centos_wp'     # Instalamos wordpress
end

include_recipe 'wordpress::post_install'