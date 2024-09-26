{ config, pkgs, ... }:

{
  programs.msmtp = {
    enable = true;
    accounts = {
      default = {
        auth = true;
        tls = true;
        tls_starttls = false;
        host = config.credentials.mail.host;
        user = config.credentials.mail.user;
        password = config.credentials.mail.password;
        from = config.credentials.mail.from;
      };
    };
  };
}
