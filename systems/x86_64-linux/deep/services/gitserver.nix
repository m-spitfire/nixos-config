{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    concatStringsSep
    mapAttrsToList
    optionalString
    concatStrings
    ;

  cgitrcLine = name: value: "${name}=${
    if value == true
    then "1"
    else if value == false
    then "0"
    else toString value
  }";

  mkCgitrc = let
    cfg = config.services.cgit.muradb;
  in
    pkgs.writeText "cgitrc" ''
      # global settings
      ${concatStringsSep "\n" (mapAttrsToList cgitrcLine ({virtual-root = "/";} // cfg.settings))}
      ${optionalString (cfg.scanPath != null) (cgitrcLine "scan-path" cfg.scanPath)}

      # repository settings
      ${concatStrings (
        mapAttrsToList (url: settings: ''
          ${cgitrcLine "repo.url" url}
          ${concatStringsSep "\n" (mapAttrsToList (name: cgitrcLine "repo.${name}") settings)}
        '')
        cfg.repos
      )}

      # extra config
      ${cfg.extraConfig}
    '';
  gitServerPath = "/var/lib/git-server";
in {
  users.users.git = {
    isSystemUser = true;
    group = "git";
    home = gitServerPath;
    createHome = true;
    homeMode = "755"; # group git can rx
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = config.users.users.muradb.openssh.authorizedKeys.keys;
    uid = 976;
  };
  users.groups.git.gid = 974;

  environment.etc."cgitrc".source = mkCgitrc;
  services = {
    openssh = {
      enable = true;
      settings.AllowUsers = ["git"];
      extraConfig = ''
        Match user git
          AllowTcpForwarding no
          AllowAgentForwarding no
          PasswordAuthentication no
          PermitTTY no
          X11Forwarding no
      '';
    };
    cgit.muradb = {
      enable = false;
      scanPath = gitServerPath;
      settings = {
        root-title = "Git Repos";
        root-desc = "Hosted with Cgit on NixOS";
        favicon = "/cgit-css/favicon.ico";
      };
      extraConfig = ''
        virtual-root=/
        css=/cgit-css/cgit.css
        logo=/cgit-css/cgit.png

        mimetype.html=text/html
        mimetype.js=text/javascript
        mimetype.css=text/css
        mimetype.pl=text/x-script.perl
        mimetype.pm=text/x-script.perl-module
        mimetype.py=text/x-script.python
        mimetype.png=image/png
        mimetype.gif=image/gif
        mimetype.jpg=image/jpeg
        mimetype.jpeg=image/jpeg

        about-filter=${config.services.cgit.muradb.package}/lib/cgit/filters/about-formatting.sh
        source-filter=${config.services.cgit.muradb.package}/lib/cgit/filters/syntax-highlighting.py

        readme=:README.md
        readme=:README.txt
        readme=:README.html
        readme=:README
      '';
    };

    caddy.virtualHosts."git.000376.xyz".extraConfig = ''
      import auth
          handle_path /cgit-css/* {
            root * ${config.services.cgit.muradb.package}/cgit/
            file_server
          }
          handle {
            cgi * ${config.services.cgit.muradb.package}/cgit/cgit.cgi
          }
    '';
  };
}
