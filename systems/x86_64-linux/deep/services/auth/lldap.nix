{config, ...}: let
  domain = "000376";
  tld = "xyz";
  host = "${domain}.${tld}";
  cfg = config.services.lldap;
in {
  services = {
    lldap = {
      enable = true;
      settings = {
        ldap_base_dn = "dc=${domain},dc=${tld}";
        database_url = "postgresql://lldap@localhost/lldap?host=/run/postgresql";
        force_ldap_user_pass_reset = "always";
      };
      environment = {
        LLDAP_JWT_SECRET_FILE = config.sops.secrets."deep/lldap/jwt_secret".path;
        LLDAP_KEY_SEED_FILE = config.sops.secrets."deep/lldap/key_seed".path;
        LLDAP_LDAP_USER_PASS_FILE = config.sops.secrets."deep/lldap/admin_password".path;
      };
    };
    caddy.virtualHosts."users.${host}".extraConfig = ''
      reverse_proxy :${toString cfg.settings.http_port}
    '';
  };

  systemd.services.lldap = let
    dependencies = [
      "postgresql.service"
    ];
  in {
    # LLDAP requires PostgreSQL to be running
    after = dependencies;
    requires = dependencies;
  };

  # Setup a user and group for LLDAP
  users = {
    users.lldap = {
      group = "lldap";
      isSystemUser = true;
    };
    groups.lldap = {};
  };
  sops.secrets = {
    "deep/lldap/jwt_secret".owner = "lldap";
    "deep/lldap/key_seed".owner = "lldap";
    "deep/lldap/admin_password".owner = "lldap";
  };
}
