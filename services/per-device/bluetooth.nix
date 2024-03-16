{ config, pkgs, ... }:

{
  hardware.bluetooth =  {
    enable = true;
    powerOnBoot = true;
  };

  environment.systemPackages = with pkgs; [ 
    bluez-tools
  ];
}