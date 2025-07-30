{
  config,
  lib,
  ...
}: let
  cfg = config.services.vikunja;
  domain = "tasks.000376.xyz";
  url = "https://${domain}";
in {
  services = {
    vikunja = {
      enable = true;
      frontendScheme = "https";
      frontendHostname = domain;
      database = {
        type = "postgres";
        host = "/run/postgresql";
      };
      settings = {
        service = {
          timezone = "Asia/Baku";
          jwtttl = 7889400;
          publicurl = url;
        };
        # https://github.com/go-vikunja/vikunja/issues/916
        cors.origins = [ url ];
        auth = {
          local.enabled = false;
          openid = {
            enabled = true;
            redirecturl = "https://${cfg.frontendHostname}/auth/openid/";
            providers.authelia = {
              name = "Authelia";
              authurl = "https://auth.000376.xyz";
              clientid = "vikunja";
            };
          };
        };
      };
      environmentFiles = [config.sops.templates.vikunja-secret.path];
    };
    caddy.virtualHosts.${domain}.extraConfig = ''
      import auth
      reverse_proxy :3456
    '';
    authelia.instances.deep.settings.access_control.rules = [
      {
        # Required to use the Vikunja mobile app
        domain = domain;
        policy = "bypass";
        resources = ["/api.*"];
      }
    ];
  };

  systemd.services.vikunja = let
    dependencies = [
      "postgresql.service"
    ];
  in {
    after = dependencies;
    requires = dependencies;
    # DynamicUser screws up sops-nix ownership
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "vikunja";
      Group = "vikunja";
    };
  };

  users = {
    users.vikunja = {
      isSystemUser = true;
      group = "vikunja";
    };
    groups.vikunja = {};
  };

  sops = {
    templates.vikunja-secret = {
      content = ''
        VIKUNJA_AUTH_OPENID_PROVIDERS_AUTHELIA_CLIENTSECRET="${config.sops.placeholder."deep/vikunja/client_secret"}"
      '';
    };
    secrets."deep/vikunja/client_secret".owner = "vikunja";
  };
}
