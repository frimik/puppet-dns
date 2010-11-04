define dns::zone ($zonetype){
    include dns
    include dns::params

    $zone = $name
    $filename = "db.${zone}"
    $dnsdir = $dns::params::dnsdir
    $zonefilename = "${type}/${name}"

    concat::fragment {
        "dns_zone_${zone}":
            target => "${dnsdir}/named.conf.zones",
            content => template("dns/zone.pp.erb");
    }

}

