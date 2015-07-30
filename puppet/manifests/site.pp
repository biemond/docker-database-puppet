#

node 'default' {
  include oradb_os
  include oradb_12c
  include oradb_configuration
}

# operating system settings for Database
class oradb_os {

  $groups = ['oinstall','dba' ,'oper' ]

  group { $groups :
    ensure      => present,
  }

  user { 'oracle' :
    ensure      => present,
    uid         => 500,
    gid         => 'oinstall',
    groups      => $groups,
    shell       => '/bin/bash',
    password    => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
    home        => "/home/oracle",
    comment     => "This user oracle was created by Puppet",
    require     => Group[$groups],
    managehome  => true,
  }

  $install = [ 'binutils.x86_64', 'compat-libstdc++-33.x86_64', 'glibc.x86_64','ksh.x86_64','libaio.x86_64',
               'libgcc.x86_64', 'libstdc++.x86_64', 'make.x86_64','compat-libcap1.x86_64', 'gcc.x86_64',
               'gcc-c++.x86_64','glibc-devel.x86_64','libaio-devel.x86_64','libstdc++-devel.x86_64',
               'sysstat.x86_64','unixODBC-devel','glibc.i686','libXext.x86_64','libXtst.x86_64','unzip']


  package { $install:
    ensure  => present,
  }

  class { 'limits':
     config => {
                '*'       => { 'nofile'  => { soft => '2048'   , hard => '8192',   },},
                'oracle'  => { 'nofile'  => { soft => '65536'  , hard => '65536',  },
                                'nproc'  => { soft => '2048'   , hard => '16384',  },
                                'stack'  => { soft => '10240'  ,},},
                },
     use_hiera => false,
  }

}

class oradb_12c {
  require oradb_os

    oradb::installdb{ '12.1.0.1_Linux-x86-64':
      version                   => '12.1.0.1',
      file                      => 'linuxamd64_12c_database',
      database_type             => 'SE',
      oracle_base               => '/oracle',
      oracle_home               => '/oracle/product/12.1/db',
      user_base_dir             => '/home',
      bash_profile              => false,
      user                      => 'oracle',
      group                     => 'dba',
      group_install             => 'oinstall',
      group_oper                => 'oper',
      download_dir              => '/var/tmp/install',
      remote_file               => false,
      puppet_download_mnt_point => '/software',
    }

    oradb::net{ 'config net':
      oracle_home  => '/oracle/product/12.1/db',
      version      => '12.1',
      user         => 'oracle',
      group        => 'dba',
      download_dir => "/var/tmp/install",
      require      => Oradb::Installdb['12.1.0.1_Linux-x86-64'],
    }

    oradb::listener{'start listener':
      oracle_base  => '/oracle',
      oracle_home  => '/oracle/product/12.1/db',
      user         => 'oracle',
      group        => 'dba',
      action       => 'start',
      require      => Oradb::Net['config net'],
    }

    oradb::database{ 'oraDb':
      oracle_base               => '/oracle',
      oracle_home               => '/oracle/product/12.1/db',
      version                   => '12.1',
      user                      => 'oracle',
      group                     => 'dba',
      download_dir              => "/var/tmp/install",
      action                    => 'create',
      db_name                   => 'orcl',
      db_domain                 => 'example.com',
      sys_password              => 'Welcome01',
      system_password           => 'Welcome01',
      data_file_destination     => "/oracle/oradata",
      recovery_area_destination => "/oracle/flash_recovery_area",
      character_set             => "AL32UTF8",
      nationalcharacter_set     => "UTF8",
      init_params               => "open_cursors=400,processes=200,job_queue_processes=2",
      sample_schema             => 'TRUE',
      memory_percentage         => "40",
      memory_total              => "800",
      database_type             => "MULTIPURPOSE",
      require                   => Oradb::Listener['start listener'],
    }

    oradb::dbactions{ 'start oraDb':
      oracle_home             => '/oracle/product/12.1/db',
      user                    => 'oracle',
      group                   => 'dba',
      action                  => 'start',
      db_name                 => 'orcl',
      require                 => Oradb::Database['oraDb'],
    }

    oradb::autostartdatabase{ 'autostart oracle':
      oracle_home             => '/oracle/product/12.1/db',
      user                    => 'oracle',
      db_name                 => 'soarepos',
      require                 => Oradb::Dbactions['start oraDb'],
    }

}

class oradb_configuration {
  require oradb_12c

  # tablespace {'MY_TS':
  #   ensure                    => present,
  #   size                      => 100M,
  #   datafile                  => 'my_ts.dbf',
  #   logging                   => 'yes',
  #   bigfile                   => 'yes',
  #   autoextend                => on,
  #   next                      => 100M,
  #   max_size                  => 12288M,
  #   extent_management         => local,
  #   segment_space_management  => auto,
  # }

  # role {'APPS':
  #   ensure    => present,
  # }

  # oracle_user{'TESTUSER':
  #   ensure                    => present,
  #   temporary_tablespace      => 'TEMP',
  #   default_tablespace        => 'MY_TS',
  #   password                  => 'testuser',
  #   grants                    => ['SELECT ANY TABLE',
  #                                 'CONNECT',
  #                                 'RESOURCE',
  #                                 'APPS'],
  #   quotas                    => { "MY_TS" => 'unlimited'},
  #   require                   => [Tablespace['MY_TS'],
  #                                 Role['APPS']],
  # }
}