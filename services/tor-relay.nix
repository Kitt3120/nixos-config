{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.tor-relay = {
    ContactInfo = lib.mkOption {
      type = lib.types.str;
    };

    Address = lib.mkOption {
      type = lib.types.str;
    };

    Nickname = lib.mkOption {
      type = lib.types.str;
    };

    role = lib.mkOption {
      default = "relay";
      type = lib.types.str;
    };

    ExitRelay = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };

    ExitPolicy = lib.mkOption {
      default = "reject *:*";
      type = lib.types.str;
    };

    BridgeRelay = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };

    openFirewall = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };

    ORPort = lib.mkOption {
      default = 9001;
      type = lib.types.int;
    };

    BandwidthRate = lib.mkOption {
      type = lib.types.str;
    };

    BandwidthBurst = lib.mkOption {
      type = lib.types.str;
    };
  };

  config.services.tor = {
    enable = true;
    openFirewall = config.tor-relay.openFirewall;
    relay = {
      enable = true;
      role = config.tor-relay.role;
    };
    settings = {
      ContactInfo = config.tor-relay.ContactInfo;
      Address = config.tor-relay.Address;
      Nickname = config.tor-relay.Nickname;
      ExitRelay = config.tor-relay.ExitRelay;
      ExitPolicy = config.tor-relay.ExitPolicy;
      BridgeRelay = config.tor-relay.BridgeRelay;
      ORPort = config.tor-relay.ORPort;
      BandwidthRate = config.tor-relay.BandwidthRate;
      BandwidthBurst = config.tor-relay.BandwidthBurst;
      SOCKSPort = 0;
      SocksPolicy = [ "reject *:*" ];
    };
  };
}
