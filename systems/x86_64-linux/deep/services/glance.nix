{
  config,
  lib,
  ...
}: {
  services.glance = {
    enable = true;
    settings = {
      server = {
        proxied = true;
      };
      auth = {
        secret-key = {
          _secret = config.sops.secrets."deep/glance/secret_key".path;
        };
        users = {
          muradb.password = {
            _secret = config.sops.secrets."deep/glance/password".path;
          };
        };
      };
      theme = {
        background-color = "240 21 15";
        contrast-multiplier = 1.2;
        primary-color = "217 92 83";
        positive-color = "115 54 76";
        negative-color = "347 70 65";
      };
      pages = [
        {
          name = "Box";
          width = "slim";
          center-vertically = true;
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "search";
                  search-engine = "google";
                  autofocus = true;
                }
                {
                  type = "monitor";
                  cache = "1m";
                  title = "Services";
                  sites = [
                    {
                      title = "Vaultwarden";
                      url = "https://vault.000376.xyz";
                      icon = "si:vaultwarden";
                    }
                    {
                      title = "Memos";
                      url = "https://memos.000376.xyz";
                      icon = "di:memos.png";
                    }
                    {
                      title = "Git";
                      url = "https://git.000376.xyz";
                      icon = "di:git";
                    }
                    {
                      title = "Actual";
                      url = "https://actual.000376.xyz";
                      icon = "di:actual-budget";
                    }
                    {
                      title = "Navidrome";
                      url = "https://music.000376.xyz";
                      icon = "di:navidrome";
                    }
                  ];
                }
                {
                  type = "bookmarks";
                  groups = [
                    {
                      title = "General";
                      links = [
                        {
                          title = "Gmail";
                          url = "https://mail.google.com/mail/u/0/";
                        }
                        {
                          title = "Github";
                          url = "https://github.com/";
                        }
                      ];
                    }
                    {
                      title = "Entertainment";
                      links = [
                        {
                          title = "Youtube";
                          url = "https://youtube.com";
                        }
                      ];
                    }
                    {
                      title = "Social";
                      links = [
                        {
                          title = "Twitter";
                          url = "https://twitter.com/";
                        }
                        {
                          title = "Reddit";
                          url = "https://reddit.com/";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  location = "Sumqayit, Azerbaijan";
                }
                {
                  type = "to-do";
                }
                {
                  type = "server-stats";
                  servers = [
                    {
                      type = "local";
                    }
                  ];
                }
              ];
            }
          ];
        }
        {
          name = "Feeds";
          desktop-navigation-width = "slim";
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "split-column";
                  max-columns = 3;
                  widgets = let
                    redditAuth = {
                      name = {
                        _secret = config.sops.secrets."deep/glance/reddit/name".path;
                      };
                      id = {
                        _secret = config.sops.secrets."deep/glance/reddit/id".path;
                      };
                      secret = {
                        _secret = config.sops.secrets."deep/glance/reddit/secret".path;
                      };
                    };
                  in [
                    # TODO: write function like subredditConf "selfhosted"
                    {
                      type = "reddit";
                      subreddit = "selfhosted";
                      collapse-after = 15;
                      app-auth = redditAuth;
                    }
                    {
                      type = "reddit";
                      subreddit = "neovim";
                      collapse-after = 15;
                      app-auth = redditAuth;
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
  # systemd.services.glance.serviceConfig = {
  #   User = "glance";
  #   Group = "glance";
  #   DynamicUser = lib.mkForce false;
  # };
  users = {
    users.glance = {
      group = "glance";
      isSystemUser = true;
    };
    groups.glance = {};
  };
  services.caddy.virtualHosts."dash.000376.xyz".extraConfig = ''
    reverse_proxy 127.0.0.1:${toString config.services.glance.settings.server.port}
  '';
  sops.secrets = {
    "deep/glance/secret_key".owner = "glance";
    "deep/glance/password".owner = "glance";
    "deep/glance/reddit/name".owner = "glance";
    "deep/glance/reddit/id".owner = "glance";
    "deep/glance/reddit/secret".owner = "glance";
  };
}
