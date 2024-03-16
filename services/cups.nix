{ config, pkgs, ... }:

{
  services.printing = {
    enable = true;
    webInterface = true;
    startWhenNeeded = false;
    openFirewall = false;
    listenAddresses = [ "localhost:631" ];
    defaultShared = false;
    cups-pdf.enable = true;
    drivers = with pkgs; [
      cups-pk-helper
      cups-filters
      ghostscript
      cups-kyodialog
      cups-kyocera
      foomatic-db
      foomatic-db-engine
      foomatic-db-ppds
      foomatic-db-nonfree
      foomatic-db-ppds-withNonfreeDb
      foomatic-filters
      gutenprint
      gutenprintBin
      hplip
      hplipWithPlugin
      splix
    ];
  };

  services.system-config-printer.enable = true;
  programs.system-config-printer.enable = true;

  environment.systemPackages = with pkgs; [
    cups-pk-helper
    cups-filters
    cups-kyodialog
    cups-kyocera
    ghostscript
    foomatic-db
    foomatic-db-engine
    foomatic-db-ppds
    foomatic-db-nonfree
    foomatic-db-ppds-withNonfreeDb
    foomatic-filters
    gutenprint
    gutenprintBin
    hplip
    hplipWithPlugin
    splix
  ];
}