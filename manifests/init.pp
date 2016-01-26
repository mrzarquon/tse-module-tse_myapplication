class tse_myapplication {
  contain apache
  contain java

  exec {'disable selinux':
    command => '/usr/sbin/setenforce 0',
    unless => '/usr/sbin/getenforce | /bin/grep Permissive',
  }

  file { '/var/www/myapplication' :
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0644',
  }

  file { '/var/www/myapplication/index.html' :
    ensure => file,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0644',
    content => "hello World! from ${::ec2_metadata['public-hostname']}",
  }

  apache::vhost { $::ec2_metadata['public-hostname']:
    port          => '8080',
    docroot       => '/var/www/user',
    docroot_owner => 'apache',
    docroot_group => 'apache',
    require       => File['/var/www/myapplication/index.html'],
  }
}
