{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    getExe
    ;

  cfg = config.custom.suites.common;
in {
  options.custom.suites.common.enable = mkEnableOption "settings that most homes will want enabled";

  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  config = mkIf cfg.enable {
    custom = {
      nix.enable = true;
      programs = {
        atuin.enable = true;
        bat.enable = true;
        bottom.enable = true;
        fish.enable = true;
        git.enable = true;
        gpg.enable = true;
        neovim.enable = true;
        starship.enable = true;
        # tealdeer.enable = true;
      };
      security = {
        secrets.enable = true;
      };
    };
    programs = {
      eza.enable = true;
      direnv.enable = true;
      # Let Home Manager install and manage itself
      home-manager.enable = true;
      # Integrates nix-index with command-not-found helper
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
      pay-respects.enable = true;
      zoxide = {
        enable = true;
        options = [
          "--cmd cd"
        ];
      };
    };

    home = {
      # Programs that don't require any configuration
      packages = with pkgs; [
        dust
        fd
        ffmpeg
        file
        imagemagick
        jq
        just
        ouch
        pciutils
        ripgrep
        sops
        systemctl-tui
        tree
        usbutils
        vimv-rs
        dnsutils
        dogdns
        unixtools.netstat
        wget
        curl
        tmux
      ];
      # Handy aliases
      shellAliases = {
        cat = "bat";
        jrn = "sudo journalctl";
        sys = "sudo systemctl";
      };
    };

    stylix.enable = true;
    stylix.autoEnable = false;
    stylix.base16Scheme = let
      theme = "catppuccin-mocha";
    in "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
  };
}
