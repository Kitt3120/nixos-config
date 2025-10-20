{ config, lib, ... }:

{
  options.settings.tor-relay = {
    ContactInfo = lib.mkOption { type = lib.types.str; };

    Address = lib.mkOption { type = lib.types.str; };

    Nickname = lib.mkOption { type = lib.types.str; };

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

    BandwidthRate = lib.mkOption { type = lib.types.str; };

    BandwidthBurst = lib.mkOption { type = lib.types.str; };
  };

  config.services.tor = {
    enable = true;
    openFirewall = config.settings.tor-relay.openFirewall;
    relay = {
      enable = true;
      role = config.settings.tor-relay.role;
    };
    settings = {
      ContactInfo = config.settings.tor-relay.ContactInfo;
      Address = config.settings.tor-relay.Address;
      Nickname = config.settings.tor-relay.Nickname;
      ExitRelay = config.settings.tor-relay.ExitRelay;
      ExitPolicy = config.settings.tor-relay.ExitPolicy;
      BridgeRelay = config.settings.tor-relay.BridgeRelay;
      ORPort = config.settings.tor-relay.ORPort;
      BandwidthRate = config.settings.tor-relay.BandwidthRate;
      BandwidthBurst = config.settings.tor-relay.BandwidthBurst;
      SOCKSPort = 0;
      SocksPolicy = [ "reject *:*" ];
    };
  };
}
