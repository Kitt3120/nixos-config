{ config, pkgs, ... }:

{
  imports = [ ../../networking/per-device/nftables.nix ];
}
