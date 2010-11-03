define dns::zone ($type){
    include dns
    include dns::params

    $zone = $name
    $filename = "db.${zone}"
    $dns_dir = $dns::params::dns_dir
    $zonefilename = "${type}/${name}"

    concat::fragment {
        "dns_zone_${zone}":
            target => "${dns_dir}/named.conf.zones",
            content => tempalte("dns/zone.pp.erb");
    }

}

