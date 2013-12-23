
$ip = "10.0.0.60"
$nmsk ="255.255.255.0"
$gw = "10.0.0.138"
$ns = "10.0.0.138"

file { "/etc/network/interfaces":
	path => '/etc/network/interfaces',
  	owner => 'root',
	group => 'root',
	mode => '644',
	content => template("servbop/interfaces")
}

file { "/etc/resolv.conf":
	path => '/etc/resolv.conf',
  	owner => 'root',
	group => 'root',
	mode => '644',
	content => 'nameserver 10.0.0.138'
}

exec { "restart network":
    command => "ifup eth0",
    path    => "/sbin/",
}

package { 'chromium-browser':
	ensure => installed
}

package { 'samba-client':
	ensure => installed
}


package { 'cifs-utils':
	ensure => installed
}


file { "nas mount":
	path => '/mnt/downloadz',
	ensure => directory,
        owner  => "root",
        group  => "root",
        mode   => "0755",
}

file {'smb credentials':
  path   => '/etc/auto.smb.credentials',
  source => 'puppet:///modules/etc/auto.smb.credentials',
}


mount { 'downloadz':
    name    => '/mnt/downloadz',
    ensure  => 'mounted',
    device  => '//10.0.0.31/media/',
    fstype  => 'cifs',
    atboot  => true,
    options => 'credentials=/etc/auto.smb.credentials',
    require => [File['smb credentials'],Package['samba-client'],File['nas mount']],
}

package { 'tree':
	ensure => installed
}

package { 'vim':
	ensure => installed
}

package { 'openssh-server':
	ensure => installed
}

package { 'ntp':
	ensure => installed
}


service { "ntp":
    enable => true,
    ensure => running,
}

