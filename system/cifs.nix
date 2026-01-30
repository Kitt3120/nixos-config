{ pkgs, ... }:

{
  boot = {
    kernelModules = [
      "cifs"
      "autofs4"
    ];

    supportedFilesystems = [
      "cifs"
    ];
  };

  environment.systemPackages = with pkgs; [ cifs-utils ];
}
