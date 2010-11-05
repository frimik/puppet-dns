define dns::zone ($zonetype="master",$soa,$reverse="false"){
    include dns
    include dns::params

    $zone = $name
    $filename = "db.${zone}"
    $dnsdir = $dns::params::dnsdir
    $zonefilename = "${type}/${name}"
    $publicviewpath = $dns::params::publicviewpath
    $zonefilepath = $dns::params::zonefilepath

    concat::fragment {
        "dns_zone_${zone}": # this sets the named zones config
            target => "$publicviewpath",
            content => template("dns/publicView.conf.erb");
    }

}

