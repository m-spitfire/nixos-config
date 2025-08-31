_: {
  services = {
    navidrome = {
      enable = true;
      group = "media";
      settings = {
        MusicFolder = "/media/music";
      };
    };
    caddy.virtualHosts."music.000376.xyz".extraConfig = ''
      reverse_proxy :4533
    '';
  };
}
