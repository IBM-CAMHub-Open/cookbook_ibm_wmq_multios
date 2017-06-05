#
# Cookbook Name:: mq80
# Recipe:: prereq
#
# Copyright IBM Corp. 2016, 2017
#
# <> Prerequisites recipe (prereq.rb)
# <> This recipe configures the operating prerequisites for the product.

ibm_cloud_utils_hostsfile_update 'update_the_etc_hosts_file' do
  action :updateshosts
end
# This will only work if the VM has access to rubygems.org
# Otherwise the gem should be installed during bootstrap
chef_gem 'chef-vault' do
  action :install
  compile_time true
end

####
expand_area = node['wmq']['expand_area']
setup_base = expand_area + '/base'

#if node['platform_family'] == 'aix'
#  filesets = setup_base + '/aix/' + node['wmq']['aix-version']
#end

install_dir = node['wmq']['install_dir']
evidence_path = node['ibm']['evidence_path']

swap_file_size = node['wmq']['swap_file_size']
swap_file_name = node['wmq']['swap_file']

# Create users and groups
# ------------------------------------------------------------------------------

Chef::Log.info("Creating users and groups")
case node['platform_family']
when 'rhel', 'centos', 'fedora'
  node['wmq']['os_users'].each_pair do |_k, u|
    next if u['ldap_user'] == 'true' || u['name'].nil?
    group u['gid'] do
      action :create
      not_if { u['gid'].nil? }
    end
    next if u['name'] == 'root'
    user u['name'] do
      supports 'manage_home' => true
      comment u['comment']
      gid u['gid']
      home u['home']
      shell u['shell']
      action :create
    end
    directory u['home'] do
      recursive true
      action :create
      owner u['name']
      group u['gid']
    end
  end
end

# KERNEL PARAMS
# ------------------------------------------------------------------------------

Chef::Log.info("Setting kernel parameters")
case node['platform_family']
when 'rhel', 'centos', 'fedora'

  bash 'sysctl_reload' do
    code 'source /etc/init.d/functions && apply_sysctl'
    action :nothing
  end
end

case node['platform_family']
when 'rhel', 'centos', 'fedora'
  directory '/etc/sysctl.d' do
    mode '0755'
  end
end

case node['platform_family']
when 'rhel', 'centos', 'fedora'
  template '/etc/sysctl.d/kernel_params.conf' do
    mode 0644
    variables(
      'net_core_rmem_default' => node['wmq']['net_core_rmem_default'],
      'net_core_rmem_max' => node['wmq']['net_core_rmem_max'],
      'net_core_wmem_default' => node['wmq']['net_core_wmem_default'],
      'net_core_wmem_max' => node['wmq']['net_core_wmem_max'],
      'net_ipv4_tcp_rmem' => node['wmq']['net_ipv4_tcp_rmem'],
      'net_ipv4_tcp_wmem' => node['wmq']['net_ipv4_tcp_wmem'],
      'net_ipv4_tcp_sack' => node['wmq']['net_ipv4_tcp_sack'],
      'net_ipv4_tcp_timestamps' => node['wmq']['net_ipv4_tcp_timestamps'],
      'net_ipv4_tcp_window_scaling' => node['wmq']['net_ipv4_tcp_window_scaling'],
      'net_ipv4_tcp_keepalive_time' => node['wmq']['net_ipv4_tcp_keepalive_time'],
      'net_ipv4_tcp_keepalive_intvl' => node['wmq']['net_ipv4_tcp_keepalive_intvl'],
      'net_ipv4_tcp_fin_timeout' => node['wmq']['net_ipv4_tcp_fin_timeout'],
      'vm_swappiness' => node['wmq']['vm_swappiness']
    )
    notifies :run, 'bash[sysctl_reload]', :immediately
  end
end

# Configure Shell Limits and System Configuration Parameters
# ------------------------------------------------------------------------------
Chef::Log.info("Configuring Shell and ulimit for mqm user")
case node['platform_family']
when 'rhel', 'centos', 'fedora'
  execute 'set_ulimit' do
    command "echo 'ulimit -n 10240' >> /root/.bashrc; . /root/.bashrc"
    not_if { IO.popen('cat /root/.bashrc').readlines.join.include? 'ulimit -n 10240' }
  end
end

case node['platform_family']
when 'rhel', 'centos', 'fedora'
  template '/etc/security/limits.conf' do
    owner 'root'
    group 'root'
    source 'wmq-limits.conf.erb'
    variables(
      'user' => node['wmq']['os_users']['mqm']['name'],
      'nofile_value' => node['wmq']['nofile_value']
    )
  end
end

# Linux Package installation
# ------------------------------------------------------------------------------

prereqs =  node['wmq']['prereqs']
Chef::Log.info("Installing pre-requisite packages. #{prereqs}")
case node['platform_family']
when 'rhel', 'centos', 'fedora'
  prereqs.each do |p|
    package p do
      package_name p
      action :upgrade
    end
  end
end


# Preparation base directory for installation
# ------------------------------------------------------------------------------
Chef::Log.info("Configuring base directory #{install_dir}")
case node['platform_family']
when 'rhel', 'centos', 'fedora'
  directory install_dir do
    owner 'root'
    group 'root'
    mode node['wmq']['perms']
    action :create
    recursive true
    not_if { wmq_installed? }
  end
end

# Preparation base directory for packages unpack
# ------------------------------------------------------------------------------

Chef::Log.info("Configuring expand area #{setup_base}")
directory setup_base do
  owner 'root'
  group 'root'
  mode '0775'
  action :create
  recursive true
  not_if { wmq_installed? }
end


# Create Evidence Log directory
# ------------------------------------------------------------------------------

Chef::Log.info("Configuring evidence directory #{evidence_path}")
directory evidence_path do
  recursive true
  action :create
end

# Create data & logs directories
# ------------------------------------------------------------------------------
Chef::Log.info("Configuring mq log and data directory #{node['wmq']['data_dir']}, #{node['wmq']['log_dir']}")
case node['platform_family']
when 'rhel', 'centos', 'fedora'
  [node['wmq']['data_dir'], node['wmq']['log_dir']].each do |dirs|
    directory dirs do
      owner node['wmq']['os_users']['mqm']['name']
      group node['wmq']['os_users']['mqm']['gid']
      mode '0775'
      recursive true
      action :create
    end
  end
end

# Create a regular swap file
# ------------------------------------------------------------------------------
Chef::Log.info("Creating swap file #{swap_file_name} of size #{swap_file_size}")
case node['platform_family']
when 'rhel', 'centos', 'fedora'
  execute 'creating swapfile' do
    command "/bin/dd if=/dev/zero of=#{swap_file_name} bs=1M count=#{swap_file_size}"
    action :run
    creates swap_file_name
    not_if { File.exist? swap_file_name }
  end
end

# Format the regular swap file, already created in previous step
# ------------------------------------------------------------------------------
Chef::Log.info("Format swap file #{swap_file_name}")
case node['platform_family']
when 'rhel', 'centos', 'fedora'
  execute 'formatting swapfile' do
    command "/sbin/mkswap -L local #{swap_file_name}"
    action :run
    only_if { File.exist? swap_file_name }
    not_if  { IO.popen("swapon -s | grep #{swap_file_name}").readlines.join.include? swap_file_name }
  end
end

# Mount the swap file
# ------------------------------------------------------------------------------
Chef::Log.info("Mount swap file #{swap_file_name}")
case node['platform_family']
when 'rhel', 'centos', 'fedora'
  mount 'none' do
    device swap_file_name
    fstype 'swap'
    options ['sw']
    dump 0
    pass 0
    action :enable
    only_if { File.exist? swap_file_name }
  end
end

Chef::Log.info("Activate swap file #{swap_file_name}")
case node['platform_family']
when 'rhel', 'centos', 'fedora'
  execute 'swap activation' do
    command '/sbin/swapon -a'
    action :run
    only_if { File.exist? swap_file_name }
    not_if  { IO.popen("swapon -s | grep #{swap_file_name}").readlines.join.include? swap_file_name }
  end
end
