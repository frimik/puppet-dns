define dns::zone ($zonetype){
    include dns
    include dns::params

    $zone = $name
    $filename = "db.${zone}"
    $dnsdir = $dns::params::dnsdir
    $zonefilename = "${type}/${name}"
    $publicviewpath = $dns::params::publicviewpath

    concat::fragment {
        "dns_zone_${zone}":
            target => "$publicviewpath",
            content => template("dns/publicView.conf.erb");
    }

}

