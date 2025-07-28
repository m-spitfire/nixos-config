{ config
, lib
, pkgs
, ...
}:
{
  services.actual = {
    enable = true;
    settings = {
      loginMethod = "openid";
      allowedLoginMethods = ["openid"];
      openId = {
        discoveryURL = "https://auth.000376.xyz";
        client_id =  "actual-budget";
        client_secret = "6JwJzREGbIMgdLskI41oyefx7HPcesHsHD8hKMdIsR6zPRfq8mf3NZRj5EUQ3zr9";
        server_hostname = "https://actual.000376.xyz";
        authMethod = "oauth2";
      };
    };
  };
  services.caddy.virtualHosts."actual.000376.xyz".extraConfig = ''
    encode gzip zstd
    reverse_proxy 127.0.0.1:3000
  '';
}
