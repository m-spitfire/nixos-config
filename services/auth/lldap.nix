{ config
, lib
, ...
}:
let
  domain = "000376";
  tld = "xyz";
  host = "${domain}.${tld}";
  authelia = "authelia-deep";
  cfg = config.services.lldap;
in
{
  services = {
    lldap = {
      enable = true;
      settings = {
        ldap_base_dn = "dc=${domain},dc=${tld}";
        database_url = "postgresql://lldap@localhost/lldap?host=/run/postgresql";
      };
      environment = {
        LLDAP_JWT_SECRET_FILE = config.age.secrets."deep_lldap_jwt_secret".path;
        LLDAP_KEY_SEED_FILE = config.age.secrets."deep_lldap_key_seed".path;
        LLDAP_LDAP_USER_PASS_FILE = config.age.secrets."deep_lldap_admin_password".path;
      };
    };
    caddy.virtualHosts."users.${host}".extraConfig = ''
      reverse_proxy :${toString cfg.settings.http_port}
    '';
  };

  systemd.services.lldap =
    let
      dependencies = [
        "postgresql.service"
      ];
    in
    {
      # LLDAP requires PostgreSQL to be running
      after = dependencies;
      requires = dependencies;
      # DynamicUser screws up sops-nix ownership because
      # the user doesn't exist outside of runtime.
      # serviceConfig.DynamicUser = lib.mkForce false;
    };

  # Setup a user and group for LLDAP
  users = {
    users.lldap = {
      group = "lldap";
      isSystemUser = true;
    };
    groups.lldap = { };
  };

  age.secrets =
    {
      "deep_lldap_jwt_secret" =
        {
          file = ../../secrets/deep_lldap_jwt_secret.age;
          owner = "lldap";
        };
      "deep_lldap_key_seed" = {
        file = ../../secrets/deep_lldap_key_seed.age;
        owner = "lldap";
      };
      "deep_lldap_admin_password" = {
        file = ../../secrets/deep_lldap_admin_password.age;
        owner = "lldap";
      };
    };
    services.caddy.virtualHosts."lldap.000376.xyz".extraConfig = ''
      reverse_proxy 127.0.0.1:17170
    '';
}
