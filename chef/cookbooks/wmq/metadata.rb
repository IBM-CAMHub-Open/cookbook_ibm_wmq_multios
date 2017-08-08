name             'wmq'
maintainer       'IBM Corp'
maintainer_email ''
license 'Copyright IBM Corp. 2012, 2017'
depends 'ibm_cloud_utils'
description <<-EOH
## DESCRIPTION

The wmq cookbook contains features and functions to support the installation and management of IBM WebSphere MQSeries.

## Platforms Support

* RHEL 6.x
* RHEL 7.x

## Versions

* IBM WebSphere MQSeries V8.0
* IBM WebSphere MQSeries V9.0

## Use Cases

Currently on single node (non HA) only.

* Single installation with no configuration. This will entail configuring the kernel, installing pre-requisite libraries, installing the base and fixpack for IBM MQSeries. This pattern is relevant on a single node only.
* Single installation with 1..n queue managers defined. Queue Managers are defined using the following structure.
```python

    "wmq": {
      "qmgr": {
          "qmgr1": {
            "name": "QMGR1",
            "description": "Default Queue Manager",
            "listener_port": "1414",
            "loggingtype": "lc",
            "primarylogs": "10",
            "secondarylogs": "20",
            "logsize": "16384",
            "dlq": "SYSTEM.DEAD.LETTER.QUEUE"
          }
       }
```
## Platform Pre-Requisites

* Linux YUM Repository - An onsite linux YUM Repsoitory is required.

## Software Repository

SW_REPO_ROOT -> Stored in the ['ibm']['sw_repo'] attribute.

Relative to the software repository, the installation files must be stored in the following location.

* BASE FILES   -> /mq/[v80|v90]/base
* FIXPACK FILES -> /mq/[v80|v90]/maint

The following is a description of files needed on the REPO Server depending on version and architecture.

```python

Base Install Files
==================

case node['wmq]['version']
when '8.0'
  case os
  when 'linux'
    case node['kernel']['machine']
    when 'x86_64'
      force_default['wmq]['archive_names'] = {
        'base' => { 'filename' => 'WS_MQ_LINUX_ON_X86_64_V8.0_IMG.tar.gz',
                    'sha256' =>  '6d1db6949a2a97606eb62cc7f43977bbdf61bdd229f1a1085ad05b6fb800f176'}
      }
    when 'powerpc'
      force_default['wmq]['archive_names'] = {
        'base' => { 'filename' => 'WS_MQ_FOR_AIX_V8.0_EIMAGE.tar.tgz',
                    'sha256' =>  '6d1db6949a2a97606eb62cc7f43977bbdf61bdd229f1a1085ad05b6fb800f176'}
      }
    when 's390x'
      force_default['wmq]['archive_names'] = {
        'base' => { 'filename' => 'WS_MQ_LINUX_SYS_Z_64B_V8.0_IMG.tar.gz',
                    'sha256' =>  '6d1db6949a2a97606eb62cc7f43977bbdf61bdd229f1a1085ad05b6fb800f176'}
      }
    end
  end
when '9.0'
  case os
  when 'linux'
    case node['kernel']['machine']
    when 'x86_64'
      force_default['wmq]['archive_names'] = {
        'base' => { 'filename' => 'IBM_MQ_9.0.0.0_LINUX_X86-64.tar.gz', 
                    'sha256' =>  'd16efd8113bede1439c1be4865befe7f3193648b70f08646a0fa0ad1a42a996a'}
      }
    when 'powerpc'
      force_default['wmq]['archive_names'] = {
        'base' => { 'filename' => 'WS_MQ_FOR_AIX_V9.0.0_EIMAGE.tar.tgz',
                    'sha256' =>  'd16efd8113bede1439c1be4865befe7f3193648b70f08646a0fa0ad1a42a996a'}
      }
    when 's390x'
      force_default['wmq]['archive_names'] = {
        'base' => { 'filename' => 'WS_MQ_LINUX_SYS_Z_64B_V9.0.0_IMG.tar.gz',
                    'sha256' =>  'd16efd8113bede1439c1be4865befe7f3193648b70f08646a0fa0ad1a42a996a'}
      }
    end
  end
end

Fixpack Files
=============

case node['wmq']['version']
when '8.0'
  case node['os']
  when 'linux'
    case node['kernel']['machine']
    when 'x86_64'
      force_default['wmq']['fixpack_names'] = {
        'fixpack' => { 'filename' => '8.0.0-WS-MQ-LinuxX64-FP000{node['wmq']['fixpack']}.tar.gz' }
      }
    when 'powerpc'
      force_default['wmq']['fixpack_names'] = {
        'fixpack' => { 'filename' => '8.0.0-WS-MQ-LinuxPPC64-FP000{node['wmq']['fixpack']}.tar.gz' }
      }
    when 's390x'
      force_default['wmq']['fixpack_names'] = {
        'fixpack' => { 'filename' => '8.0.0-WS-MQ-LinuxS390X-FP000{node['wmq']['fixpack']}.tar.gz' }
      }
    end
  end
when '9.0'
  case node['os']
  when 'linux'
    case node['kernel']['machine']
    when 'x86_64'
      force_default['wmq']['fixpack_names'] = {
        'fixpack' => { 'filename' => '9.0.0-WS-MQ-LinuxX64-FP000{node['wmq']['fixpack']}.tar.gz' }
      }
  end
end

```
## Environment Variables

```python
default['ibm']['sw_repo']                 - URL of the Software Repository.
default['ibm']['sw_repo_user']                    - User to access the software Repository.
default['ibm']['sw_repo_password']                - Password for the software repository, note, will exist in VAULT.
default['ibm']['sw_repo_self_signed_cert']     - Boolean indicating whether the repo uses a self signed certificate.
default['ibm']['sw_repo_auth']                 - Boolean indicating whether the software repo is secured.
default['ibm_internal']['stack_id']            - Unique ID referencing all nodes in a deployment.
default['ibm_internal']['stack_name']          - Common name for the deployed stack.
default['ibm_internal']['vault']['name']       - Name of the Vault, will be generated by the environment.
default['ibm_internal']['vault']['item']       - Vault Item to reference, will be  generated by the environment.
```
EOH

version '0.1.36'

attribute 'wmq/advanced',
          :choice => ['true', 'false'],
          :default => 'false',
          :description => 'Whether to install MQSeries Advanced Componenets - File Transfer, Telemetry, AMS',
          :displayname => 'MQSeriesAdvanced',
          :options => ['true', 'false'],
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'true',
          :type => 'string'
attribute 'wmq/data_dir',
          :default => '/var/mqm',
          :description => 'The MQSeries data directory, reccomended /var/mqm',
          :displayname => 'MQSeriesVersion',
          :parm_type => 'component',
          :precedence_level => 'role',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/fixpack',
          :default => '5',
          :description => 'The Fixpack of MQSeries to install.',
          :displayname => 'MQSeriesFixpack',
          :max => '20',
          :min => '1',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/global_mq_service',
          :default => 'true',
          :description => 'WebSphere MQ Global Service control',
          :displayname => 'nofile_value',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/install_dir',
          :default => '/opt/mqm',
          :description => 'The directory to install MQSeries Binaries, reccomended /opt/mqm',
          :displayname => 'InstallDir',
          :parm_type => 'component',
          :precedence_level => 'role',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/log_dir',
          :default => '/var/mqm/log',
          :description => 'MQseries Log Directory, reccomended -> node[wmq][data_dir]/log',
          :displayname => 'MQSeriesVersion',
          :parm_type => 'component',
          :precedence_level => 'role',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/net_core_rmem_default',
          :default => '262144',
          :description => 'WebSphere MQ Server Kernel Configuration net_core_rmem_default',
          :displayname => 'net_core_rmem_default',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/net_core_rmem_max',
          :default => '4194304',
          :description => 'WebSphere MQ Server Kernel Configuration net_core_rmem_max',
          :displayname => 'net_core_rmem_max',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/net_core_wmem_default',
          :default => '262144',
          :description => 'WebSphere MQ Server Kernel Configuration net_core_wmem_default',
          :displayname => 'net_core_wmem_default',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/net_core_wmem_max',
          :default => '1048576',
          :description => 'WebSphere MQ Server Kernel Configuration net_core_wmem_max',
          :displayname => 'net_core_wmem_max',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/net_ipv4_tcp_fin_timeout',
          :default => '60',
          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_fin_timeout',
          :displayname => 'net_ipv4_tcp_fin_timeout',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/net_ipv4_tcp_keepalive_intvl',
          :default => '75',
          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_keepalive_intvl',
          :displayname => 'net_ipv4_tcp_keepalive_intvl',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/net_ipv4_tcp_keepalive_time',
          :default => '7200',
          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_keepalive_time',
          :displayname => 'net_ipv4_tcp_keepalive_time',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/net_ipv4_tcp_rmem',
          :default => '4096    87380   4194304',
          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_rmem',
          :displayname => 'net_ipv4_tcp_rmem',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/net_ipv4_tcp_sack',
          :default => '1',
          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_sack',
          :displayname => 'net_ipv4_tcp_sack',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/net_ipv4_tcp_timestamps',
          :default => '1',
          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_timestamps',
          :displayname => 'net_ipv4_tcp_timestamps',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/net_ipv4_tcp_window_scaling',
          :default => '1',
          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_window_scaling',
          :displayname => 'net_ipv4_tcp_window_scaling',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/net_ipv4_tcp_wmem',
          :default => '4096    87380   4194304',
          :description => 'WebSphere MQ Server Kernel Configuration net_ipv4_tcp_wmem',
          :displayname => 'net_ipv4_tcp_wmem',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/nofile_value',
          :default => '10240',
          :description => 'WebSphere MQ Server Ulimit Nofile Value',
          :displayname => 'nofile_value',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/os_users/mqm/comment',
          :default => 'MQSeries User',
          :description => 'Comment associated with the MQSeries USer',
          :displayname => 'MQUserComment',
          :parm_type => 'component',
          :precedence_level => 'role',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/os_users/mqm/gid',
          :default => 'mqm',
          :description => 'The Group of the MQSeries User',
          :displayname => 'MQUSerGID',
          :parm_type => 'component',
          :precedence_level => 'role',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/os_users/mqm/home',
          :default => '/home/mqm',
          :description => 'Home directory of the MQSeries User.',
          :displayname => 'MQUserHomeDir',
          :parm_type => 'component',
          :precedence_level => 'role',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/os_users/mqm/ldap_user',
          :default => 'false',
          :description => 'A flag which indicates whether to create the MQ USer locally, or utilise an LDAP based user.',
          :displayname => 'MQUSerLDAP',
          :parm_type => 'component',
          :precedence_level => 'role',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'boolean'
attribute 'wmq/os_users/mqm/name',
          :default => 'mqm',
          :description => 'Name of the Unix OS User that owns and controls MQSeries',
          :displayname => 'MQSeriesUser',
          :parm_type => 'component',
          :precedence_level => 'role',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/os_users/mqm/shell',
          :default => '/bin/bash',
          :description => 'Location of the MQSeries User Shell',
          :displayname => 'MQUserShell',
          :parm_type => 'component',
          :precedence_level => 'role',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/perms',
          :default => '775',
          :description => 'Default permissions for MQSeries files on Unix',
          :displayname => 'perms',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/qmgr/qmgr($INDEX)/description',
          :default => 'Queue Manager 1',
          :description => 'Description of the Queue Manager',
          :displayname => 'QMGRDesc',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/qmgr/qmgr($INDEX)/dlq',
          :default => 'SYSTEM.DEAD.LETTER.QUEUE',
          :description => 'Queue Manager Dead Letter Queue',
          :displayname => 'QMGRDeadLetterQueue',
          :parm_type => 'pattern',
          :precedence_level => 'role',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/qmgr/qmgr($INDEX)/listener_port',
          :default => '1414',
          :description => 'Port the Queue Manager listens on.',
          :displayname => 'QMGRPort',
          :max => '50000',
          :min => '1025',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/qmgr/qmgr($INDEX)/loggingtype',
          :choice => ['ll', 'lc'],
          :default => 'lc',
          :description => 'Type of logging to use ll(Linear), lc(Circular)',
          :displayname => 'QMGRLogging',
          :options => ['ll', 'lc'],
          :parm_type => 'pattern',
          :precedence_level => 'role',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'true',
          :type => 'string'
attribute 'wmq/qmgr/qmgr($INDEX)/logsize',
          :default => '16384',
          :description => 'Size of the MQSeries Logs',
          :displayname => 'QMGRLogSize',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/qmgr/qmgr($INDEX)/name',
          :default => 'qmgr1',
          :description => 'Name of the Queue Manager to Create',
          :displayname => 'QMGRName',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/qmgr/qmgr($INDEX)/primarylogs',
          :default => '10',
          :description => 'Number of Primary Logs to create.',
          :displayname => 'QMGRPrimaryLogs',
          :parm_type => 'pattern',
          :precedence_level => 'role',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/qmgr/qmgr($INDEX)/secondarylogs',
          :default => '20',
          :description => 'Number of Secondary Logs',
          :displayname => 'QMGRSecondaryLogs',
          :parm_type => 'pattern',
          :precedence_level => 'role',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/qmgr_dir',
          :default => '/var/mqm/qmgrs',
          :description => 'The MQSeries Queue Manager Directory, reccomended node[wmq][data_dir]/qmgrs',
          :displayname => 'MQSeriesVersion',
          :parm_type => 'component',
          :precedence_level => 'role',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/service_name',
          :default => 'mq',
          :description => 'WebSphere MQ Service name',
          :displayname => 'nofile_value',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/swap_file',
          :default => '/swapfile',
          :description => 'swap file name',
          :displayname => 'swap_file',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/swap_file_size',
          :default => '512',
          :description => 'Dwap size in mega bytes',
          :displayname => 'swap_file_size',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
attribute 'wmq/version',
          :choice => ['8.0', '9.0'],
          :default => '8.0',
          :description => 'The Version of MQSeries to install, eg, 8.0',
          :displayname => 'MQSeriesVersion',
          :options => ['8.0', '9.0'],
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'true',
          :type => 'string'
attribute 'wmq/vm_swappiness',
          :default => '0',
          :description => 'WebSphere MQ Server Kernel Configuration vm_swappiness',
          :displayname => 'vm_swappiness',
          :parm_type => 'node',
          :precedence_level => 'node',
          :required => 'recommended',
          :secret => 'false',
          :selectable => 'false',
          :type => 'string'
recipe 'wmq::cleanup.rb', '
Cleanup recipe (cleanup.rb)
Perform post-install cleanup
'
recipe 'wmq::config_qmgr_single.rb', '
Create one or more queue managers if they do not already exist.
'
recipe 'wmq::default.rb', '
Default recipe
'
recipe 'wmq::fixpack.rb', '
Installation recipe (fixpack.rb)
This recipe performs the fixpack installation for the product
'
recipe 'wmq::gather_evidence.rb', '
Evidence gathering recipe (gather_evidence.rb)
This recipe will collect functional product information and store it in an archive.
'
recipe 'wmq::install.rb', '
Installation recipe (install.rb)
This recipe performs the product installation.
'
recipe 'wmq::prereq.rb', '
Prerequisites recipe (prereq.rb)
This recipe configures the operating prerequisites for the product.
'
recipe 'wmq::prereq_check.rb', '
Prerequisite Check Recipe (preq_check.rb)
This recipe wil check the target platform to ensure installation is possible
'
recipe 'wmq::service.rb', '
Create the MQ service and enables it on RHEL 7
Create the MQ service file
Create the MQ service script
Enable and start the httpd service
Enable the MQ service
'
recipe 'wmq::start_qmgr.rb', '
Start all queue managers defined for the target node.
'
recipe 'wmq::stop_qmgr.rb', '
Stop all queue managers defined for the target node.
'
