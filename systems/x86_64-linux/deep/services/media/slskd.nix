{config, ...}: {
  services = {
    slskd = {
      enable = true;
      group = "media";
      domain = "slskd.000376.xyz";
      settings = {
        directories = {
          incomplete = "/media/slskd/incomplete";
          downloads = "/media/slskd/downloaded";
        };
        shares.directories = ["/media/music/Archspire/"];
        web = {
          authentication = {
            disabled = true;
          };
        };
      };
      openFirewall = true;
      environmentFile = config.sops.templates.slskd-env.path;
    };
    caddy.virtualHosts."slskd.000376.xyz".extraConfig = ''
      import auth
      reverse_proxy :${toString config.services.slskd.settings.web.port} {
        header_up Upgrade "websocket"
        header_up Connection "Upgrade"
      }
    '';
  };

  sops = {
    templates.slskd-env = {
      content = ''
        SLSKD_SLSK_USERNAME="${config.sops.placeholder."deep/slskd/username"}"
        SLSKD_SLSK_PASSWORD="${config.sops.placeholder."deep/slskd/password"}"
      '';
    };
    secrets."deep/slskd/password".owner = "slskd";
    secrets."deep/slskd/username".owner = "slskd";
  };
}
