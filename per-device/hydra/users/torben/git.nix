{ config, pkgs, lib, ... }:

{
  home-manager.users.torben.xdg.configFile."git/config".text = ''
    [user]
            email = "torben@schweren.dev"
            name = "Torben Schweren"
            signingKey = "/home/torben/.ssh/id_ed25519"
  '';
}