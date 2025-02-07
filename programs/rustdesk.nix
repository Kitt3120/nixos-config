{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ rustdesk ];
}
