{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.custom.programs.gpg;
in {
  options.custom.programs.gpg.enable = mkEnableOption "GnuPG";

  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      mutableKeys = false;
      mutableTrust = false;
    };

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-curses;
      # Cache for 1 year
      maxCacheTtl = 31536000;
    };
  };
}
