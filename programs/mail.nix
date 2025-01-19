{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.credentials.mail = {
    host = lib.mkOption {
      type = lib.types.str;
    };

    user = lib.mkOption {
      type = lib.types.str;
    };

    password = lib.mkOption {
      type = lib.types.str;
    };

    from = lib.mkOption {
      type = lib.types.str;
    };
  };

  config.programs.msmtp = {
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
