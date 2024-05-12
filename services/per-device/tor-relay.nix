{ config, pkgs, ... }:

{
  services.tor = {
    enable = true;
    openFirewall = config.tor.openFirewall;
    relay = {
      enable = true;
      role = config.tor.role;
    };
    settings = {
      ContactInfo = config.tor.ContactInfo;
      Address = config.tor.Address;
      Nickname = config.tor.Nickname;
      ExitRelay = config.tor.ExitRelay;
      ExitPolicy = config.tor.ExitPolicy;
      BridgeRelay = config.tor.BridgeRelay;
      ORPort = config.tor.ORPort;
      BandwidthRate = config.tor.BandwidthRate;
      BandwidthBurst = config.tor.BandwidthBurst;
      SOCKSPort = 0;
      SocksPolicy = [ "reject *:*" ];
    };
  };
}