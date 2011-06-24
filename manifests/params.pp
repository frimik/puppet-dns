class dns::params (
    $rndc_alg    = "hmac-md5",
    $rndc_secret = "APIEQEbbut1VcDEC/p8PRg==",
    $vardir      = "/var/named"
  ) {
# TODO: zone should be group owned by bind
  $dnsdir = $operatingsystem ? {
      debian  => "/etc/bind",
      ubuntu  => "/etc/bind9",
      centos  => "/etc/dns",
      darwin  => "/etc/dns",
      freebsd => "/etc/namedb",
  }
  $dns_server_package = $operatingsystem ? {
      debian  => "bind9",
      ubuntu  => "bind9",
      centos  => "bind",
      default => undef, # zjl: fbsd
  }
  $namedconf_path = $operatingsystem ? {
    debian    => "${dnsdir}/named.conf",
    freebsd   => "${dnsdir}/named.conf",
    default   => "/etc/named.conf",
  }
  $optionspath = $operatingsystem ? {
      darwin  => "${dnsdir}/options.conf.apple",
      default => "${dnsdir}/options.conf",
  }

  # pertaining to rndc
  $rndckeypath = $operatingsystem ? {
    debian   => "${dnsdir}/rndc.key",
    freebsd  => "${dnsdir}/rndc.key",
    default  => "/etc/rndc.key",
  }

  #pertaining to views
  $publicviewpath = $operatingsystem ? {
      darwin  => "${dnsdir}/publicView.conf.apple",
      default => "${dnsdir}/publicView.conf",
  }
  $publicview = $operatingsystem ? {
      darwin  => "com.apple.ServerAdmin.DNS.public",
      default => "DNS.public",
  }

  $zonefilepath = "${vardir}/zones"
  $namedservicename = $operatingsystem ? {
      darwin  => "org.isc.named",
      centos  => "named",
      debian  => "bind9",
      freebsd => "named",
  }
}

