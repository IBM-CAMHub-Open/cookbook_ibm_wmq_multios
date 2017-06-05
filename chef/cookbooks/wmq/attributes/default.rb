###############################################################################################
#
# Cookbook Name:: wmq
# Recipe:: default
#
# Copyright IBM Corp. 2016, 2017
#################################################################################################


#-------------------------------------------------------------------------------
# Installation Versions
#-------------------------------------------------------------------------------

# <> Version of MQSeries to install
# <md> attribute 'wmq/version',
# <md>          :displayname => 'MQSeriesVersion',
# <md>          :description => 'The Version of MQSeries to install.',
# <md>          :choice => [ '8.0',
# <md>                       '9.0' ],
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '8.0',
# <md>          :selectable => 'true',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'

default['wmq']['version'] = "8.0"

# <> Version of MQSeries to install
# <md>attribute 'wmq/fixpack',
# <md>          :displayname => 'MQSeriesFixpack',
# <md>          :description => 'The Fixpack of MQSeries to install.',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '5',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :parm_type => 'node',
# <md>          :min => '1',
# <md>          :secret => 'false',
# <md>          :max => '20'

default['wmq']['fixpack'] = "5"

# <> Version of GSK To Install
# <md>attribute 'wmq/gskversion',
# <md>          :displayname => 'MQSeriesGSKVersion',
# <md>          :description => 'The Version of GSK install with MQSeries',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '8.0.0-4',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'

default['wmq']['gskversion'] = "8.0.0-4"

#-------------------------------------------------------------------------------
# Installation Directories
#-------------------------------------------------------------------------------

# <> Base Installation Directory
# <md>attribute 'wmq/install_dir',
# <md>          :displayname => 'InstallDir',
# <md>          :description => 'The directory to install MQSeries Binaries, reccomended /opt/mqm',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '/opt/mqm',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'role',
# <md>          :secret => 'false',
# <md>          :parm_type => 'component'

default['wmq']['install_dir'] = '/opt/mqm'

# <> Base Data Installation Directory
# <md>attribute 'wmq/data_dir',
# <md>          :displayname => 'MQSeriesVersion',
# <md>          :description => 'The MQSeries data directory, reccomended /var/mqm',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '/var/mqm',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'role',
# <md>          :secret => 'false',
# <md>          :parm_type => 'component'

default['wmq']['data_dir'] = '/var/mqm'

# <> WebSphere MQ Server QMGR Directory
# <md>attribute 'wmq/qmgr_dir',
# <md>          :displayname => 'MQSeriesVersion',
# <md>          :description => 'The MQSeries Queue Manager Directory, reccomended node[wmq][data_dir]/qmgrs',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '/var/mqm/qmgrs',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'role',
# <md>          :secret => 'false',
# <md>          :parm_type => 'component'

default['wmq']['qmgr_dir'] = node['wmq']['data_dir'] + '/qmgrs'

# <> WebSphere MQ Server Log directory
# <md>attribute 'wmq/log_dir',
# <md>          :displayname => 'MQSeriesVersion',
# <md>          :description => 'MQseries Log Directory, reccomended -> node[wmq][data_dir]/log',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '/var/mqm/log',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'role',
# <md>          :secret => 'false',
# <md>          :parm_type => 'component'

default['wmq']['log_dir'] = node['wmq']['data_dir'] + '/log'

#-------------------------------------------------------------------------------
# Pre-Requisites
#-------------------------------------------------------------------------------

# <md>attribute 'wmq/os_users/mqm/name',
# <md>          :displayname => 'MQSeriesUser',
# <md>          :description => 'Name of the Unix OS User that owns and controls MQSeries',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => 'mqm',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'role',
# <md>          :secret => 'false',
# <md>          :parm_type => 'component'
# <md>attribute 'wmq/os_users/mqm/gid',
# <md>          :displayname => 'MQUSerGID',
# <md>          :description => 'The Group of the MQSeries User',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => 'mqm',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'role',
# <md>          :secret => 'false',
# <md>          :parm_type => 'component'
# <md>attribute 'wmq/os_users/mqm/ldap_user',
# <md>          :displayname => 'MQUSerLDAP',
# <md>          :description => 'A flag which indicates whether to create the MQ USer locally, or utilise an LDAP based user.',
# <md>          :type => 'boolean',
# <md>          :required => 'recommended',
# <md>          :default => 'false',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'role',
# <md>          :secret => 'false',
# <md>          :parm_type => 'component'
# <md>attribute 'wmq/os_users/mqm/home',
# <md>          :displayname => 'MQUserHomeDir',
# <md>          :description => 'Home directory of the MQSeries User.',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '/home/mqm',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'role',
# <md>          :secret => 'false',
# <md>          :parm_type => 'component'
# <md>attribute 'wmq/os_users/mqm/comment',
# <md>          :displayname => 'MQUserComment',
# <md>          :description => 'Comment associated with the MQSeries USer',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => 'MQSeries User',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'role',
# <md>          :secret => 'false',
# <md>          :parm_type => 'component'
# <md>attribute 'wmq/os_users/mqm/shell',
# <md>          :displayname => 'MQUserShell',
# <md>          :description => 'Location of the MQSeries User Shell',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '/bin/bash',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'role',
# <md>          :secret => 'false',
# <md>          :parm_type => 'component'

# <> WebSphere MQ OS users
default['wmq']['os_users'] = {
  'mqm' => {
    'name' => 'mqm',
    'gid' => 'mqm',
    'ldap_user' => 'false',
    'home' => "/home/mqm",
    'comment' => 'MQSeries User',
    'shell' => '/bin/bash'
  }
}


#-------------------------------------------------------------------------------
# Linux Kernel Configuration
#-------------------------------------------------------------------------------

# <> default file/directory parameters
# <md>attribute 'wmq/perms',
# <md>          :displayname => 'perms',
# <md>          :description => 'Default permissions for MQSeries files on Unix',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '775',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['perms'] = '775'

# <> swap size in mega bytes
# <md>attribute 'wmq/swap_file_size',
# <md>          :displayname => 'swap_file_size',
# <md>          :description => 'Dwap size in mega bytes',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '512',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['swap_file_size'] = '512'

# <> swap file name
# <md>attribute 'wmq/swap_file',
# <md>          :displayname => 'swap_file',
# <md>          :description => 'swap file name',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '/swapfile',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['swap_file'] = '/swapfile'

# <> WebSphere MQ Server Kernel Configuration net_core_rmem_default
# <md>attribute 'wmq/net_core_rmem_default',
# <md>          :displayname => 'net_core_rmem_default',
# <md>          :description => 'WebSphere MQ Server Kernel Configuration net_core_rmem_default',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '262144',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['net_core_rmem_default'] = '262144'

# <> WebSphere MQ Server Kernel Configuration net_core_rmem_max
# <md>attribute 'wmq/net_core_rmem_max',
# <md>          :displayname => 'net_core_rmem_max',
# <md>          :description => 'WebSphere MQ Server Kernel Configuration net_core_rmem_max',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '4194304',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['net_core_rmem_max'] = '4194304'

# <> WebSphere MQ Server Kernel Configuration net_core_wmem_default
# <md>attribute 'wmq/net_core_wmem_default',
# <md>          :displayname => 'net_core_wmem_default',
# <md>          :description => 'WebSphere MQ Server Kernel Configuration net_core_wmem_default',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '262144',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['net_core_wmem_default'] = '262144'

# <> WebSphere MQ Server Kernel Configuration net_core_wmem_max
# <md>attribute 'wmq/net_core_wmem_max',
# <md>          :displayname => 'net_core_wmem_max',
# <md>          :description => 'WebSphere MQ Server Kernel Configuration net_core_wmem_max',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '1048576',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['net_core_wmem_max'] = '1048576'

# <> WebSphere MQ Server Kernel Configuration net_ipv4_tcp_rmem
# <md>attribute 'wmq/net_ipv4_tcp_rmem',
# <md>          :displayname => 'net_ipv4_tcp_rmem',
# <md>          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_rmem',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '4096    87380   4194304',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['net_ipv4_tcp_rmem'] = '4096    87380   4194304'

# <> WebSphere MQ Server Kernel Configuration net_ipv4_tcp_wmem
# <md>attribute 'wmq/net_ipv4_tcp_wmem',
# <md>          :displayname => 'net_ipv4_tcp_wmem',
# <md>          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_wmem',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '4096    87380   4194304',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['net_ipv4_tcp_wmem'] = '4096    87380   4194304'

# <> WebSphere MQ Server Kernel Configuration net_ipv4_tcp_sack
# <md>attribute 'wmq/net_ipv4_tcp_sack',
# <md>          :displayname => 'net_ipv4_tcp_sack',
# <md>          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_sack',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '1',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['net_ipv4_tcp_sack'] = '1'

# <> WebSphere MQ Server Kernel Configuration net_ipv4_tcp_timestamps
# <md>attribute 'wmq/net_ipv4_tcp_timestamps',
# <md>          :displayname => 'net_ipv4_tcp_timestamps',
# <md>          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_timestamps',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '1',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['net_ipv4_tcp_timestamps'] = '1'

# <> WebSphere MQ Server Kernel Configuration net_ipv4_tcp_window_scaling
# <md>attribute 'wmq/net_ipv4_tcp_window_scaling',
# <md>          :displayname => 'net_ipv4_tcp_window_scaling',
# <md>          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_window_scaling',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '1',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['net_ipv4_tcp_window_scaling'] = '1'

# <> WebSphere MQ Server Kernel Configuration net_ipv4_tcp_keepalive_time
# <md>attribute 'wmq/net_ipv4_tcp_keepalive_time',
# <md>          :displayname => 'net_ipv4_tcp_keepalive_time',
# <md>          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_keepalive_time',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '7200',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :parm_type => 'node'
default['wmq']['net_ipv4_tcp_keepalive_time'] = '7200'

# <> WebSphere MQ Server Kernel Configuration net_ipv4_tcp_keepalive_intvl
# <md>attribute 'wmq/net_ipv4_tcp_keepalive_intvl',
# <md>          :displayname => 'net_ipv4_tcp_keepalive_intvl',
# <md>          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_keepalive_intvl',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '75',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['net_ipv4_tcp_keepalive_intvl'] = '75'


# <> WebSphere MQ Server Kernel Configuration net_ipv4_tcp_fin_timeout
# <md>attribute 'wmq/net_ipv4_tcp_fin_timeout',
# <md>          :displayname => 'net_ipv4_tcp_fin_timeout',
# <md>          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_fin_timeout',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '60',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['net_ipv4_tcp_fin_timeout'] = '60'

# <> WebSphere MQ Server Kernel Configuration vm_swappiness
# <md>attribute 'wmq/vm_swappiness',
# <md>          :displayname => 'vm_swappiness',
# <md>          :description => 'WebSphere MQ Server Kernel Configuration vm_swappiness',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '0',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['vm_swappiness'] = '0'

# <> WebSphere MQ Server Ulimit Nofile Value
# <md>attribute 'wmq/nofile_value',
# <md>          :displayname => 'nofile_value',
# <md>          :description => 'WebSphere MQ Server Ulimit Nofile Value',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '10240',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
default['wmq']['nofile_value'] = '10240'

#-------------------------------------------------------------------------------
# Queue Manager Definition
#-------------------------------------------------------------------------------

# <md>attribute '$dynamicmaps/wmq/qmgr',
# <md>          :$displayname =>  'Queue Managers',
# <md>          :$key => 'qmgr',
# <md>          :$max => '4',
# <md>          :$count => '0'

# <> Definition of an MQSeries Queue Manager on a single machine
# <md>attribute 'wmq/qmgr/qmgr1/name',
# <md>          :displayname => 'QMGRName',
# <md>          :description => 'Name of the Queue Manager to Create',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => 'qmgr1',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
# <md>attribute 'wmq/qmgr/qmgr1/description',
# <md>          :displayname => 'QMGRDesc',
# <md>          :description => 'Description of the Queue Manager',
# <md>         :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => 'Queue Manager 1',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
# <md>attribute 'wmq/qmgr/qmgr1/listener_port',
# <md>          :displayname => 'QMGRPort',
# <md>          :description => 'Port the Queue Manager listens on.',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '1414',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :parm_type => 'node',
# <md>          :secret => 'false',
# <md>          :min => '1025',
# <md>          :max => '50000'
# <md>attribute 'wmq/qmgr/qmgr1/loggingtype',
# <md>          :displayname => 'QMGRLogging',
# <md>          :description => 'Type of logging to use ll(Linear), lc(Circular)',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>         :default => 'lc',
# <md>          :choice => [ 'll',
# <md>                       'lc' ],
# <md>          :selectable => 'true',
# <md>          :precedence_level => 'role',
# <md>          :secret => 'false',
# <md>          :parm_type => 'pattern'
# <md>attribute 'wmq/qmgr/qmgr1/primarylogs',
# <md>         :displayname => 'QMGRPrimaryLogs',
# <md>          :description => 'Number of Primary Logs to create.',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '10',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'role',
# <md>          :secret => 'false',\
# <md>          :parm_type => 'pattern'
# <md>attribute 'wmq/qmgr/qmgr1/secondarylogs',
# <md>          :displayname => 'QMGRSecondaryLogs',
# <md>          :description => 'Number of Secondary Logs',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '20',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'role',
# <md>          :secret => 'false',
# <md>          :parm_type => 'pattern'
# <md>attribute 'wmq/qmgr/qmgr1/logsize',
# <md>         :displayname => 'QMGRLogSize',
# <md>          :description => 'Size of the MQSeries Logs',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => '16384',
# <md>          :selectable => 'false',
# <md>          :precedence_level => 'node',
# <md>          :secret => 'false',
# <md>          :parm_type => 'node'
# <md>attribute 'wmq/qmgr/qmgr1/dlq',
# <md>          :displayname => 'QMGRDeadLetterQueue',
# <md>          :description => 'Queue Manager Dead Letter Queue',
# <md>          :type => 'string',
# <md>          :required => 'recommended',
# <md>          :default => 'SYSTEM.DEAD.LETTER.QUEUE',
# <md>         :selectable => 'false',
# <md>          :precedence_level => 'role',
# <md>          :secret => 'false',
# <md>          :parm_type => 'pattern'
default['wmq']['qmgr'] = {
  'qmgr($INDEX)' => {
    'name' => 'QMGR1',
    'description' => 'QUEUE MANAGER 1',
    'listener_port'  => '1414',
    'loggingtype'    => 'lc',
    'primarylogs'    => '10',
    'secondarylogs'  => '20',
    'logsize'        => '16384',
    'dlq'            => 'SYSTEM.DEAD.LETTER.QUEUE'
  }
}
