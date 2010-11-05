class dns {
    include dns::params

    $namedconf_path = $dns::params::namedconf_path
    $dnsdir = $dns::params::dnsdir
    $dns_server_package = $dns::params::dns_server_package
    $rndckeypath = $dns::params::rndckeypath
    $rndc_alg = $dns::params::rndc_alg
    $rndc_secret = $dns::params::rndc_secret
    $optionspath = $dns::params::optionspath
    $publicviewpath = $dns::params::publicviewpath
    $publicview = $dns::params::publicview
    $vardir = $dns::params::vardir
    $namedservicename = $dns::params::namedservicename

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
            owner   => root,
            group   => 0,
            mode    => 644,
            require => $operatingsystem ? {
                linux => Package["dns"],
                darwin => undef,
            },
            content => template("dns/named.conf.erb");
        "$dnsdir":
            ensure  => directory,
            owner   => root,
            group   => 0,
            mode    => 755;
        "$vardir":
            owner   => root,
            group   => 0,
            mode    => 755,
            ensure  => directory;
        "$optionspath":
            owner   => root,
            group   => 0,
            mode    => 0644,
            content => template("dns/options.conf.erb");
    }

    include concat::setup

    concat::fragment {
        "dns_zone_${zone}-header":
            order => 05,
            target => "$publicviewpath",
            content => template("dns/publicView.conf-header.erb");
        "dns_zone_${zone}-footer":
            order => 15,
            target => "$publicviewpath",
            content => "};";
    }
    concat { "${publicviewpath}": }

    service {
        "$namedservicename":
            enable    => "true",
            ensure    => "running",
            require   => $operatingsystem ? {
                linux => Package["dns"],
                darwin => undef,
            };
   }

    dns::rndckey {
        "rndc-key":
            secret => $rndc_secret,
            alg    => $rndc_alg;
    }
}

