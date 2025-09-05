{lib,...}: {
  services.wiki-js = {
    enable = true;
    settings = {
      port = 3001;
      db = {
        host = "/run/postgresql";
        db = "wikijs";
      };
    };
  };

  systemd.services.wiki-js.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "wikijs";
    Group = "wikijs";
  };
  users = {
    users.wikijs = {
      group = "wikijs";
      isSystemUser = true;
    };
    groups.wikijs = {};
  };

  services.caddy.virtualHosts."wiki.000376.xyz".extraConfig = ''
    reverse_proxy 0.0.0.0:3001
  '';

  sops.secrets."deep/wikijs/redirect_uri".owner = "authelia-deep";
  sops.secrets."deep/wikijs/client_secret".owner = "wikijs";
}
