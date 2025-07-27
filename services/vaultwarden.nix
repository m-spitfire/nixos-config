{ config, ... }:
{
  services.vaultwarden = {
    enable = true;
    config = {
      ADMIN_TOKEN = "$argon2id$v=19$m=65540,t=3,p=4$dHhteVF0aFRWT3RzNFNrbHllYm0ybTdIa0FIYkREdGJKbTRZODFYK2ZBZz0$nQloPHQPPsRXRIuaX1xmdv6fivEKT2KcrQ+7LRCmfbE";
      DOMAIN = "https://vault.000376.xyz";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8000;
      ROCKET_LOG = "critical";
      SIGNUPS_ALLOWED = false;
      INVITATIONS_ALLOWED = false;
    };
  };
  services.caddy.virtualHosts."vault.000376.xyz".extraConfig = ''
    log {
      level INFO
    }
    encode zstd gzip
    # Proxy everything to Rocket
    reverse_proxy 127.0.0.1:8000 {
          # Send the true remote IP to Rocket, so that Vaultwarden can put this in the
          # log, so that fail2ban can ban the correct IP.
          header_up X-Real-IP http.request.header.Cf-Connecting-Ip
    }
  '';
}
