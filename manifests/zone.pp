define dns::zone ($zonetype="master",$soa,$reverse="false",$ttl="10800",$soaip){
    $contact = "root@${name}"
    $serial = "2010110702"
    include dns
    include dns::params

    $zone = $name
    $filename = "zones/db.${zone}"
    $dnsdir = $dns::params::dnsdir
    $zonefilename = "${type}/${name}"
    $publicviewpath = $dns::params::publicviewpath
    $zonefilepath = $dns::params::zonefilepath
    $vardir = $dns::params::vardir

    include concat::setup

    concat::fragment {
        "dns_zone_${zone}": # this sets the named zones config
            target => "$publicviewpath",
            content => template("dns/publicView.conf.erb");
        "dns_zonefile_${zone}": # build zonefile header
            order => "05",
            target => "${vardir}/${filename}",
            content => template("dns/zone.header.erb");
    }

    concat { "${vardir}/${filename}": }

}

