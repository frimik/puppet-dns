class dns {
  include dns::params

  $dnsdir             = $dns::params::dnsdir
  $vardir             = $dns::params::vardir
  $rndc_alg           = $dns::params::rndc_alg
  $publicview         = $dns::params::publicview
  $rndckeypath        = $dns::params::rndckeypath
  $rndc_secret        = $dns::params::rndc_secret
  $optionspath        = $dns::params::optionspath
  $zonefilepath       = $dns::params::zonefilepath
  $publicviewpath     = $dns::params::publicviewpath
  $namedconf_path     = $dns::params::namedconf_path
  $namedservicename   = $dns::params::namedservicename
  $dns_server_package = $dns::params::dns_server_package

  if $operatingsystem != "Darwin" { #linux + fbsd specifics
    package {
      "dns":
        ensure => installed,
        name   => "$dns_server_package";
    }
  }
  if $operatingsystem != "Linux"{ #linux specifics
    package { "dnsutils": ensure => installed; }
  }

  file {
    "$namedconf_path":
      owner   => root,
      group   => bind,
      mode    => 640,
      require => $operatingsystem ? {
        darwin  => undef,
        default => Package["dns"],
      },
      content => template("dns/named.conf.erb");
    "$dnsdir":
      ensure  => directory,
      owner   => root,
      group   => bind,
      mode    => 750;
    "$vardir":
      owner   => root,
      group   => bind,
      mode    => 750,
      ensure  => directory;
    "$optionspath":
      owner   => root,
      group   => bind,
      mode    => 0640,
      content => template("dns/options.conf.erb");
    "${vardir}/named.ca":
      owner   => root,
      group   => 0,
      mode   => 644;
    "$zonefilepath":
      ensure => directory,
      owner  => root,
      group  => bind;
#  source => "puppet:///modules/dns/named.ca";	
#   "${vardir}/named.local":
#     owner   => root,
#           group   => 0,
#           mode   => 644,
#    source => "puppet:///modules/dns/named.local";
#       "${vardir}/localhost.zone":
#           owner   => root,
#           group   => 0,
#           mode   => 644,
#    source => "puppet:///modules/dns/localhost.zone";
#       "$zonefilepath":
#           owner   => root,
#           group   => 0,
#           mode   => 755,
#           ensure  => directory;
  }

  file { "/etc/bind/named.conf.default-zones":
    source => "puppet:///dns/named.conf.default-zones";
  }

  include concat::setup

  concat::fragment {
    "dns_zone_${zone}-header":
      order   => 05,
      target  => "$publicviewpath",
      notify  => Service["$namedservicename"],
      content => template("dns/publicView.conf-header.erb");
    "dns_zone_${zone}-footer":
      order   => 15,
      target  => "$publicviewpath",
      notify  => Service["$namedservicename"],
      content => "};";
  }

  concat { "${publicviewpath}": }

  service {
    "$namedservicename":
      enable     => "true",
      ensure     => "running",
      hasstatus  => "true",
      require    => $operatingsystem ? {
        darwin  => undef,
        default => Package["dns"],
      };
  }

  dns::rndckey {
    "rndc-key":
      secret => $rndc_secret,
      alg    => $rndc_alg;
  }

}

