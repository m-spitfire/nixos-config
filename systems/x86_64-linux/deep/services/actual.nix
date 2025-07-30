{
  config,
  lib,
  pkgs,
  ...
}: {
  services.actual = {
    enable = true;
    settings = {
      loginMethod = "openid";
      allowedLoginMethods = ["openid"];
      openId = {
        discoveryURL = "https://auth.000376.xyz";
        client_id = "actual-budget";
        server_hostname = "https://actual.000376.xyz";
        authMethod = "oauth2";
      };
    };
  };
  systemd.services.actual.serviceConfig = {
    EnvironmentFile = config.sops.templates.actual-secret.path;
    # DynamicUser screws up sops-nix ownership because
    # the user doesn't exist outside of runtime.
    DynamicUser = lib.mkForce false;
  };
  users = {
    users.actual = {
      group = "actual";
      isSystemUser = true;
    };
    groups.actual = {};
  };
  services.caddy.virtualHosts."actual.000376.xyz".extraConfig = ''
    encode gzip zstd
    reverse_proxy 127.0.0.1:3000
  '';
  sops = {
    templates.actual-secret = {
      content = ''
        ACTUAL_OPENID_CLIENT_SECRET="${config.sops.placeholder."deep/actual/client_secret"}"
      '';
    };
    secrets."deep/actual/client_secret".owner = "actual";
  };
}
