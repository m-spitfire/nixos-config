{
  config,
  lib,
  ...
}: let
  inherit (lib) mkAfter;
  domain = "000376";
  tld = "xyz";
  host = "${domain}.${tld}";
  ldapPort = "3890";
  authelia = "authelia-deep";
in {
  services = {
    authelia.instances.deep = {
      enable = true;
      settings = {
        notifier = {
          disable_startup_check = false;
          filesystem.filename = "/var/lib/authelia-deep/authelia_notif.txt";
        };
        theme = "auto";
        authentication_backend.ldap = {
          address = "ldap://localhost:${ldapPort}";
          base_dn = "dc=${domain},dc=${tld}";
          users_filter = "(&({username_attribute}={input})(objectClass=person))";
          groups_filter = "(member={dn})";
          user = "uid=authelia,ou=people,dc=${domain},dc=${tld}";
        };
        access_control = {
          default_policy = "deny";
          # We want this rule to be low priority so it doesn't override the others
          rules = mkAfter [
            {
              domain = "*.${host}";
              policy = "one_factor";
            }
          ];
        };
        storage.postgres = {
          address = "unix:///run/postgresql";
          database = authelia;
          username = authelia;
        };
        session = {
          redis.host = "/var/run/redis-deep/redis.sock";
          cookies = [
            {
              domain = host;
              authelia_url = "https://auth.${host}";
              # The period of time the user can be inactive for before the session is destroyed
              inactivity = "1M";
              # The period of time before the cookie expires and the session is destroyed
              expiration = "3M";
              # The period of time before the cookie expires and the session is destroyed
              # when the remember me box is checked
              remember_me = "1y";
            }
          ];
        };
        log.level = "debug";
        identity_providers.oidc = {
          cors = {
            endpoints = ["token"];
            allowed_origins_from_client_redirect_uris = true;
          };
          authorization_policies.default = {
            default_policy = "one_factor";
            rules = [
              {
                policy = "deny";
                subject = "group:lldap_strict_readonly";
              }
            ];
          };
        };
        # Necessary for Caddy integration
        # See https://www.authelia.com/integration/proxies/caddy/#implementation
        server.endpoints.authz.forward-auth.implementation = "ForwardAuth";
      };
      settingsFiles = [./oidc_clients.yaml];
      # Templates don't work correctly when parsed from Nix, so our OIDC clients are defined here
      secrets = with config.sops; {
        jwtSecretFile = secrets."deep/authelia/jwt_secret".path;
        oidcIssuerPrivateKeyFile = secrets."deep/authelia/jwks".path;
        oidcHmacSecretFile = secrets."deep/authelia/hmac_secret".path;
        sessionSecretFile = secrets."deep/authelia/session_secret".path;
        storageEncryptionKeyFile = secrets."deep/authelia/storage_encryption_key".path;
      };
      environmentVariables = with config.sops; {
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE =
          secrets."deep/authelia/lldap_authelia_password".path;
      };
    };
    caddy = {
      virtualHosts."auth.${host}".extraConfig = ''
        reverse_proxy :9091
      '';
      # A Caddy snippet that can be imported to enable Authelia in front of a service
      # Taken from https://www.authelia.com/integration/proxies/caddy/#subdomain
      extraConfig = ''
        (auth) {
            forward_auth :9091 {
                uri /api/authz/forward-auth
                copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
            }
        }
      '';
    };
  };

  # Give Authelia access to the Redis socket
  users.users.${authelia}.extraGroups = ["redis-deep"];

  systemd.services.${authelia} = let
    dependencies = [
      "lldap.service"
      "postgresql.service"
      "redis-deep.service"
    ];
  in {
    # Authelia requires LLDAP, PostgreSQL, and Redis to be running
    after = dependencies;
    requires = dependencies;
    # Required for templating
    serviceConfig.Environment = "X_AUTHELIA_CONFIG_FILTERS=template";
  };

  sops.secrets = {
    "deep/authelia/hmac_secret".owner = authelia;
    "deep/authelia/jwks".owner = authelia;
    "deep/authelia/jwt_secret".owner = authelia;
    "deep/authelia/session_secret".owner = authelia;
    "deep/authelia/storage_encryption_key".owner = authelia;
    # The password for the `authelia` LLDAP user
    "deep/authelia/lldap_authelia_password".owner = authelia;
  };
}
