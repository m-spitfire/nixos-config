{pkgs, ...}: {
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/aksdb/caddy-cgi/v2@v2.2.6"];
      hash = "sha256-Py8XQQOe3wCFxrNW2FdJ4U7So9sHtRHGFZtQiNcmdYA=";
    };
    globalConfig = ''
      # Make the main log more human readable
      log stdout_logger {
          output stdout
          format console
          exclude http.log.access
      }
    '';
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
