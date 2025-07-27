{ pkgs, ... }:
{
  config = {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/aksdb/caddy-cgi/v2@v2.2.6" ];
        hash = "sha256-pkq0PIdd4+uSyjXf24rDR6hfVVEg4YMBF6cS38W1vsA=";
      };
      virtualHosts."000376.xyz".extraConfig = ''
        respond "Hello, world!"
      '';
    };
  };
}
