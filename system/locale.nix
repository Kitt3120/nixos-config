{ config, pkgs, ... }:

{
  console.keyMap = "de";

  i18n = {
    supportedLocales = [
      "de_DE/ISO-8859-1"
      "de_DE.UTF-8/UTF-8"
      "de_DE@euro/ISO-8859-15"
      "en_GB/ISO-8859-1"
      "en_GB.UTF-8/UTF-8"
      "en_US/ISO-8859-1"
      "en_US.UTF-8/UTF-8"
    ];

    defaultLocale = "en_GB.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };
}
