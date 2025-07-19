{
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.settings = {
    sops = {
      keyFile = lib.mkOption {
        type = lib.types.path;
        default = "/root/.config/sops/age/keys.txt";
        description = "Path to the SOPS key file for decrypting secrets.";
      };

      shared-secrets = lib.mkOption {
        type = lib.types.path;
        default = ./secrets/shared.yaml;
        description = "Path to the secrets file that contains non-device-specific secrets.";
      };

      device-secrets = lib.mkOption {
        type = lib.types.path;
        description = "Path to the secrets file that contains device-specific secrets.";
        # This will be set in the settings of the device-specific profile
      };
    };
  };

  config = {
    sops = {
      defaultSopsFile = config.settings.sops.shared-secrets;
      age = {
        keyFile = config.settings.sops.keyFile;
        generateKey = false;
      };
    };
  };
}
