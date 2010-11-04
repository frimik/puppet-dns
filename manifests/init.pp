class dns {
    include dns::params
    
    $namedconf_path = $dns::params::namedconf_path
    $dnsdir = $dns::params::dnsdir
    $dns_server_package = $dns::params::dns_server_package
    $rndckeypath = $dns::params::rndckeypath
    $rndc_alg = $dns::params::rndc_alg
    $rndc_secret = $dns::params::rndc_secret

    if $operatingsystem != "Darwin" { #linux specifics
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
    }
	
	file {
		"$namedconf_path":
			owner	=> root,
			group	=> root,
			mode	=> 644,
			require	=> Package["dns"],
			content	=> template("dns/named.conf.erb");
        "$dnsdir":
            ensure => directory,
            owner => root,
            group => root,
            mode => 755;
        "$vardir": 
            owner => root,
            group => 0,
            mode => 755,
            ensure => directory;
	}

	include concat::setup
    concat { "${dnsdir}/named.conf.zones": }
   
    service {
        "named":
            enable    => "true",
            ensure    => "running",
            require   => Package["dns"];
   }

    dns::rndckey {
        "rndc-key":
            secret => $rndc_secret,
            alg    => $rndc_alg;
    }
        
        
}

