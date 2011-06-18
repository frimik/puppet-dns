dns::zone {
    "my.net": # will be $ORIGIN
        zonetype => "master",
        soa      => "ns1.my.net", # this will also be NS
        reverse  => 'false',     # default?
    "18.0.0.in-addr.arpa":    # 18.210.10.in-addr.arpa
        zonetype => "master",
        soa      => "ns1.my.net", # this will also be NS
        reverse  => 'true';
}

dns::host {
    "host1":
        ip => '10.0.0.10',
        zone => 'my.net', from above
        rectype => 'A',   #default A
}

dns::zonefile {
    "$name"
        contact => 'root@myzon.',
        soa     => 'ns1.my.net'',
}

