define dns::rndckey ($alg = "hmac-md5",$secret = "APIEQEbbut1VcDEC/p8PRg==") {
    $keyname = $name
    file {
        "$rndckeypath":
            owner => root,
            group => 0,
            mode => 0600,
            content => template("dns/rndc.key.erb");
    }
}
