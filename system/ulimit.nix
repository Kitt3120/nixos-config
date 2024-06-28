{ config, pkgs, ... }:

{
  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "-";
      value = "10240";
    }
  ];
}