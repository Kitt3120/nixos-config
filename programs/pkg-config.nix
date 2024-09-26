{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ pkg-config ];
  environment.variables.PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
}
