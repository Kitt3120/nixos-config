{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ nhentai ];

  networking.extraHosts = "104.27.206.92 nhentai.net
104.27.206.92 static.nhentai.net
104.27.206.92 t1.nhentai.net
104.27.206.92 t2.nhentai.net
104.27.206.92 t3.nhentai.net
104.27.206.92 t4.nhentai.net
104.27.206.92 t5.nhentai.net
104.27.206.92 t6.nhentai.net
104.27.206.92 t7.nhentai.net
104.27.206.92 t8.nhentai.net
104.27.206.92 t9.nhentai.net";
}
