class dns {
    include dns::params

    package { "dns": 
        ensure => installed,
        name => "${dns_server_package}";
    }

	iptables { 
        "dns":
            proto => "udp",
            dport => "53",
            jump => "ACCEPT",
	}
	
	file {
		"$namedconf_path":
			owner	=> root,
			group	=> root,
			mode	=> 644,
			require	=> Package["dns"],
			content	=> template("dns/named.conf.erb");
        "$dns_dir":
            ensure => directory,
            owner => root,
            group => root,
            mode => 755;
	}

	include concat::setup
    concat { "${dns_dir}/named.conf.zones": }
   
    service {
        "named":
            enable    => "true",
            ensure    => "running",
            require   => Package["dns"];
   }
}

