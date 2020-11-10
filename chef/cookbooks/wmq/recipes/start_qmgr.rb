#
# Cookbook Name:: wmq
# Recipe:: start_qmgr
#
# Copyright IBM Corp. 2016, 2020
#
# <> Start all queue managers defined for the target node.


###############################################################################
# START QUEUE MANAGER
###############################################################################

if platform?('redhat') || platform?('ubuntu')
  node['wmq']['qmgr'].each do |_qmgr, qmgrobject|
    execute_start_qmgr(qmgrobject)
  end
end


def execute_copy
  Chef::Log.info("Copy files for webconsole.....")
  run_cmd_copy = 'cp ' + node['wmq']['install_dir'] + '/web/mq/samp/configuration/basic_registry.xml ' + node['wmq']['data_dir'] + '/web/installations/Installation1/servers/mqweb/mqwebuser.xml'
  run_cmd_back = 'mv ' + node['wmq']['data_dir'] + '/web/installations/Installation1/servers/mqweb/mqwebuser.xml ' + node['wmq']['data_dir'] + '/web/installations/Installation1/servers/mqweb/mqwebuser.xml.bak'
  chown_file = 'chown mqm:mqm '+ node['wmq']['data_dir'] + '/web/installations/Installation1/servers/mqweb/mqwebuser.xml'
  chmod_file = 'chmod 666 '+ node['wmq']['data_dir'] + '/web/installations/Installation1/servers/mqweb/mqwebuser.xml'
  output_debug = shell_out('ls -lrt ' + node['wmq']['data_dir'] + '/web/installations/Installation1/servers/mqweb/')
  Chef::Log.info(output_debug.stdout.to_s)
  Chef::Log.info(run_cmd_back)
  output_back = shell_out(run_cmd_back)
  Chef::Log.info(output_back.stdout.to_s)
  Chef::Log.info(run_cmd_copy)
  output_copy = shell_out(run_cmd_copy)
  Chef::Log.info(output_copy.stdout.to_s)
  shell_out(chown_file)
  shell_out(chmod_file)
  output_debug = shell_out('ls -lrt ' + node['wmq']['data_dir'] + '/web/installations/Installation1/servers/mqweb/')
  Chef::Log.info(output_debug.stdout.to_s)
end    

def execute_config_webconsole
  Chef::Log.info("Set webconsole properties.....")
  execute "config_webconsole" do
      command "#{node['wmq']['install_dir']}/bin/setmqweb properties -k httpHost -v #{node['wmq']['webhost']}"
      user node['wmq']['os_users']['mqm']['name']
      group node['wmq']['os_users']['mqm']['gid']
  end
end    

def execute_start_webconsole
  Chef::Log.info("Starting webconsole.....")
  execute "start_webconsole" do
      command "#{node['wmq']['install_dir']}/bin/strmqweb"
      user node['wmq']['os_users']['mqm']['name']
      group node['wmq']['os_users']['mqm']['gid']
  end
end 

def execute_end_webconsole
  Chef::Log.info("End webconsole.....")
  execute "end_webconsole" do
      command "#{node['wmq']['install_dir']}/bin/endmqweb"
      user node['wmq']['os_users']['mqm']['name']
      group node['wmq']['os_users']['mqm']['gid']
  end
end 

#Start webconsole
if File.exist?(node['wmq']['data_dir'] + '/web/installations/Installation1/servers/mqweb/mqwebuser.xml.bak')
  Chef::Log.info("Configured webconsole.....")
else
  case node['wmq']['version']
  when '9.0'
    unless node['wmq']['webhost'].nil?
        Chef::Log.info("Configure webconsole.....")
        execute_copy()
        execute_config_webconsole()
        execute_start_webconsole()
    end
  end
end

