#
# Cookbook:: database
# Recipe:: default
#
# Copyright:: 2025, The Authors, All Rights Reserved.
case node['platform_family']
when 'debian', 'ubuntu'
    execute "update" do
        command "apt update -y && apt upgrade -y"
        action :run
    end
    include_recipe 'database::ubuntu'
when 'rhel', 'fedora'
    execute "update" do
        command "sudo dnf update -y && sudo dnf upgrade -y"
        action :run
    end
    include_recipe 'database::centos'
end