  dns::host {
    "ns1.zlan":
      ip => "192.168.1.10",
      zone => "example.com";
  }

  dns::zone {
    "example.com":
      soaip => "192.168.100.125",
      soa   => "ns1.example.com";
  }

