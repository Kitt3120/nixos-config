{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ metasploit ];
}
