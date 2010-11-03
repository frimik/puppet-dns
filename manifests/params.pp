class dns::params {
    $dns_dir = $operatingsystem {
        debian => "/etc/bind9",
        ubuntu => "/etc/bind9",
        centos => "/etc/dns",
        darwin => "/etc/dns",
    $dns_server_package = $operatingsystem ? {
        debian => "bind9",
        ubuntu => "bind9",
        centos => "bind",
    }
    $namedconf_path = "/etc/named.conf"


}

