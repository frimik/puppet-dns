define dns::zone (
    $zonetype="master",
    $soa,
    $reverse="false",
    $ttl="1d",
    $soaip
  ) {

  include dns
  include dns::params
  include concat::setup

  $contact = "root@${name}"
  $serial  = date()

  $zone             = $name
  $filename         = "zones/db.${zone}"
  $dnsdir           = $dns::params::dnsdir
  $zonefilename     = "${type}/${name}"
  $publicviewpath   = $dns::params::publicviewpath
  $zonefilepath     = $dns::params::zonefilepath
  $vardir           = $dns::params::vardir
  $namedservicename = $dns::params::namedservicename

  concat::fragment {
    "dns_zone_${zone}": # this sets the named zones config
      target  => "$publicviewpath",
      notify  => Service["$namedservicename"],
      content => template("dns/publicView.conf.erb");
    "dns_zonefile_${zone}": # build zonefile header
      order   => "05",
      target  => "${vardir}/${filename}",
      notify  => Service["$namedservicename"],
      content => template("dns/zone.header.erb");
  }

  concat { "${vardir}/${filename}": }

}

