_: {
  services = {
    navidrome = {
      enable = true;
      group = "media";
      settings = {
        MusicFolder = "/mnt/storagebox/music";
      };
    };
    caddy.virtualHosts."music.000376.xyz".extraConfig = ''
      reverse_proxy :4533
    '';
  };
}
