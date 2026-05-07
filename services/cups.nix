{ pkgs, ... }:

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

  # TODO: remove
  nixpkgs.config.permittedInsecurePackages = [
    "python3.13-pypdf3-1.0.6"
  ];
}
