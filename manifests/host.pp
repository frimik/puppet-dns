define dns::host ($ip,$type='A',$comment='',$zone) {

    $host = $name
    include dns
    include dns::params

    $vardir = $dns::params::vardir
    $filename = "zones/db.${zone}"
    $reverse_address = get_in_addr_arpa($ip)

    concat::fragment {
        "dns_zonefile_${zone}_{$host}": # build zonefile header
            order => "15",
            target => "${vardir}/${filename}",
            content => "${host} IN ${type} ${ip}\n";
    }

}

