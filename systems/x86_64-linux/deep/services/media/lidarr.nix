{config, ...}: {
  services.lidarr = {
    enable = true;
    group = "media";
  };
  services.caddy.virtualHosts."lidarr.000376.xyz".extraConfig = ''
    import auth
    reverse_proxy :${toString config.services.lidarr.settings.server.port}
  '';
}
