{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ rustdesk ];
}
