{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.services.memos;
in {
  custom.services.memos = {
    enable = true;
    instanceUrl = "https://memos.000376.xyz";
    port = 5550;
    mode = "dev";
  };
  services.caddy.virtualHosts."memos.000376.xyz".extraConfig = ''
    reverse_proxy 127.0.0.1:${toString cfg.port}
  '';
}
