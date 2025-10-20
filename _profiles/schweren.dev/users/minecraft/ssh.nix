{ config, ... }:

let
  username = "minecraft";
in
{
  /*
    we can't use
    users.users.<user>.openssh.authorizedKeys.keyFiles
    because it would read the files at build time, when sops hasn't decrypted them yet.
    That's why authorizedKeys.keyFiles actually prevents the usage of absolute paths.
    Thus, we hook into the systemActivation to set the keys at runtime.
    We place the keys at the same path as authorizedKeys.keyFiles would.
  */
  system.activationScripts."${username}-authorized-keys" = {
    text = ''
      mkdir -p /home/${username}/.ssh
      chown ${username}:users /home/${username}/.ssh
      chmod 700 /home/${username}/.ssh

      touch /home/${username}/.ssh/authorized_keys
      cat ${config.sops.secrets."ssh/keys/modulosaurus".path} > /home/${username}/.ssh/authorized_keys
      echo "" >> /home/${username}/.ssh/authorized_keys
      cat ${config.sops.secrets."ssh/keys/hydra".path} >> /home/${username}/.ssh/authorized_keys
      echo "" >> /home/${username}/.ssh/authorized_keys
      cat ${config.sops.secrets."ssh/keys/mrmeeseeks".path} >> /home/${username}/.ssh/authorized_keys
      echo "" >> /home/${username}/.ssh/authorized_keys
      cat ${config.sops.secrets."ssh/keys/schweren.dev".path} >> /home/${username}/.ssh/authorized_keys
      echo "" >> /home/${username}/.ssh/authorized_keys
      cat ${config.sops.secrets."ssh/keys/grapheneos".path} >> /home/${username}/.ssh/authorized_keys
      echo "" >> /home/${username}/.ssh/authorized_keys
      chown ${username}:users /home/${username}/.ssh/authorized_keys
      chmod 600 /home/${username}/.ssh/authorized_keys
    '';
  };
}
