{
  pkgs,
  config,
  ...
}: let
  cfg = config.services.caddy;
in {
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/aksdb/caddy-cgi/v2@v2.2.6"
        "github.com/caddy-dns/cloudflare@v0.2.1"
      ];
      hash = "sha256-YIKXUmOLGc/taCzqIXq/WnBK9kXlfu/z0/pfHnl6g00=";
    };
    email = "carlsonmu@gmail.com";
    virtualHosts."olympus.000376.xyz".extraConfig = ''
      reverse_proxy :8008
    '';
    globalConfig = ''
      acme_dns cloudflare {env.CF_API_TOKEN}
      # Make the main log more human readable
      log stdout_logger {
          output stdout
          format console
          exclude http.log.access
      }
    '';
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.templates.caddy-secrets.path;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  sops = {
    templates.caddy-secrets = {
      content = ''
        CF_API_TOKEN="${config.sops.placeholder."deep/caddy/cf_api_token"}"
      '';
      owner = cfg.user;
    };
    secrets = {
      "deep/caddy/cf_api_token".owner = cfg.user;
    };
  };
}
