#
# Cookbook Name:: wmq
# Recipe:: prereq_check
#
# Copyright IBM Corp. 2016, 2017
#
# <> Prerequisite Check Recipe (preq_check.rb)
# <> This recipe wil check the target platform to ensure installation is possible


# This will only work if the VM has access to rubygems.org
# Otherwise the gem should be installed during bootstrap
chef_gem 'chef-vault' do
  action :install
  compile_time true
end

# CHECK FREE SPACE ON THE DISKS
# ------------------------------------------------------------------------------
ibm_cloud_utils_freespace 'check-freespace-tmp-directory' do
  path node['ibm']['temp_dir']
  required_space 1024
  continue true
  action :check
  error_message "Please make sure you have at least 1GB free space under #{node['ibm']['temp_dir']}"
  not_if { wmq_installed? }
end

ibm_cloud_utils_freespace 'check-freespace-expand-area' do
  path node['wmq']['expand_area']
  required_space 1024
  continue true
  action :check
  error_message "Please make sure you have at least 1GB free space under #{node['wmq']['expand_area']}"
  not_if { wmq_installed? }
end

# Check Free Space on MQ File System
# ------------------------------------------------------------------------------
ibm_cloud_utils_freespace 'check-freespace-wmq-directory' do
  path node['wmq']['install_dir']
  required_space 1024
  continue true
  action :check
  error_message "Please make sure you have at least 1GB free space under #{node['wmq']['install_dir']}"
  not_if { wmq_installed? }
end

# Check suppored OS Versions
# ------------------------------------------------------------------------------
ibm_cloud_utils_supported_os_check 'check-supported-opeartingsystem-for-pattern' do
  supported_os_list node['wmq']['OS_supported']
  action :check
  error_message "Unsupported Operating System Version, the following OS is supported #{node['wmq']['OS_supported']}"
  not_if { wmq_installed? }
end

# Check Repository Files Exist
# ------------------------------------------------------------------------------
require 'chef-vault'
node['wmq']['archive_names'].each_pair do |_p, v|
  filename = v['filename']
  Chef::Log.info("Checking if file #{filename} exists")
  ruby_block "base_packages_validation" do
    block do
      require 'net/http'
      require 'openssl'
      encrypted_id = node['wmq']['vault']['encrypted_id']
      chef_vault = node['wmq']['vault']['name']
      sw_repo_user = node['ibm']['sw_repo_user']
      sw_repo_password = chef_vault_item(chef_vault, encrypted_id)['ibm']['sw_repo_password']
      uri = URI.parse(node['ibm']['sw_repo'])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if node['ibm']['sw_repo'].include? "https"
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE if node['ibm']['sw_repo_self_signed_cert'] == "true"
      request = Net::HTTP::Head.new(node['wmq']['sw_repo_path'] + '/base/' + filename)
      request.basic_auth(sw_repo_user, sw_repo_password) if node['ibm']['sw_repo_auth'] == "true" # ~password_checker
      begin
        res = http.request(request)
      rescue OpenSSL::SSL::SSLError
        raise "Self signed certificate detected when trying to access #{node['ibm']['sw_repo']}. Please use sw_repo_self_signed_cert == \"true\" "
      end
      print "\n HTTP response code is #{res.code} \n"
      print "\n =========== Package #{filename} is there! ============ \n" if res.code == "200"
      raise "#{res.code} Bad Request. The request could not be understood by the server due to malformed syntax." if res.code == "400"
      raise "#{res.code} Unauthorized. The request requires user authentication." if res.code == "401"
      raise "#{res.code} Please make sure your WMQ package is available in your binary repository" if res.code == "404"
    end
    not_if { wmq_installed? }
  end
end

upgrade_fixpack = if wmq_installed?
                    false
                  else
                     true
                  end

node['wmq']['fixpack_names'].each_pair do |_p, v|
  next if node['wmq']['fixpack'] == "0"
  fp_filename = v['filename']
  Chef::Log.info("Checking if file #{fp_filename} exists")
  ruby_block "fixpack_packages_validation" do
    block do
      require 'net/http'
      require 'openssl'
      encrypted_id = node['wmq']['vault']['encrypted_id']
      chef_vault = node['wmq']['vault']['name']
      sw_repo_user = node['ibm']['sw_repo_user']
      sw_repo_password = chef_vault_item(chef_vault, encrypted_id)['ibm']['sw_repo_password']
      uri = URI.parse(node['ibm']['sw_repo'])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if node['ibm']['sw_repo'].include? "https"
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE if node['ibm']['sw_repo_self_signed_cert'] == "true"
      request = Net::HTTP::Head.new(node['wmq']['sw_repo_path'] + '/maint/' + fp_filename)
      request.basic_auth(sw_repo_user, sw_repo_password) if node['ibm']['sw_repo_auth'] == "true" # ~password_checker
      begin
        res = http.request(request)
      rescue OpenSSL::SSL::SSLError
        raise "Self signed certificate detected when trying to access #{node['ibm']['sw_repo']}. Please use sw_repo_self_signed_cert == \"true\" "
      end
      print "\n HTTP response code is #{res.code} \n"
      print "\n =========== Package #{fp_filename} is there! ============ \n" if res.code == "200"
      raise "#{res.code} Bad Request. The request could not be understood by the server due to malformed syntax." if res.code == "400"
      raise "#{res.code} Unauthorized. The request requires user authentication." if res.code == "401"
      raise "#{res.code} Please make sure your WMQfixpack package is available in your binary repository" if res.code == "404"
    end
    only_if { upgrade_fixpack }
  end
end
