{ config, pkgs, ... }:

{

  config = {
    sops.secrets = {
      "mail/host" = {
        sopsFile = config.settings.sops.device-secrets;
        neededForUsers = true;
      };

      "mail/user" = {
        sopsFile = config.settings.sops.device-secrets;
        neededForUsers = true;
      };

      "mail/password" = {
        sopsFile = config.settings.sops.device-secrets;
        neededForUsers = true;
      };

      "mail/from" = {
        sopsFile = config.settings.sops.device-secrets;
        neededForUsers = true;
      };
    };

    # We can't just use programs.msmtp here because it always sets /etc/msmtprc
    # TODO: Keep in sync with programs.msmtp
    environment.systemPackages = [ pkgs.msmtp ];

    services.mail.sendmailSetuidWrapper = {
      program = "sendmail";
      source = "${pkgs.msmtp}/bin/sendmail";
      setuid = false;
      setgid = false;
      owner = "root";
      group = "root";
    };

    # programs.msmtp.accounts does not support evaluation of host, user, and from at runtime,
    # so we set /etc/msmtprc ourselves through systemActivation.
    system.activationScripts."mail-configuration" = {
      text = ''
        touch /etc/msmtprc
        echo "defaults" > /etc/msmtprc
        echo "account default" >> /etc/msmtprc
        echo "auth on" >> /etc/msmtprc
        echo "tls on" >> /etc/msmtprc
        echo "tls_starttls off" >> /etc/msmtprc
        echo -n "host " >> /etc/msmtprc
        cat ${config.sops.secrets."mail/host".path} >> /etc/msmtprc
        echo "" >> /etc/msmtprc
        echo -n "user " >> /etc/msmtprc
        cat ${config.sops.secrets."mail/user".path} >> /etc/msmtprc
        echo "" >> /etc/msmtprc
        echo -n "password " >> /etc/msmtprc
        cat ${config.sops.secrets."mail/password".path} >> /etc/msmtprc
        echo "" >> /etc/msmtprc
        echo -n "from " >> /etc/msmtprc
        cat ${config.sops.secrets."mail/from".path} >> /etc/msmtprc
        echo "" >> /etc/msmtprc
        chown root:root /etc/msmtprc
        chmod 600 /etc/msmtprc
      '';
    };
  };
}
