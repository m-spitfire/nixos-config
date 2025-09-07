{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.custom.nix;
in {
  options.custom.nix.enable = mkEnableOption "Nix tweaks";

  config = mkIf cfg.enable {
    nix = {
      # Use Lix, for a better experience
      # https://lix.systems
      package = pkgs.lix;

      settings = {
        # Enable New CLI and Flakes
        experimental-features = [
          "flakes"
          "nix-command"
        ];
        allowed-users = ["@wheel"];
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        use-xdg-base-directories = true;
      };
      # Every day, detects files in the store that have identical contents,
      # and replaces them with hard links to a single copy.
      # See here for why this is done daily instead of constantly: https://github.com/NixOS/nix/issues/6033
      optimise.automatic = true;
    };

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
    };
  };
}
