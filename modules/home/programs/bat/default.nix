{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.programs.bat;
in {
  options.custom.programs.bat.enable = lib.mkEnableOption "Enable bat";

  config = lib.mkIf cfg.enable {
    stylix.targets.bat.enable = true;
    programs.bat = {
      enable = true;
      # themes = pkgs.fetchurl {
      #   url = "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme";
      #   hash = "";
      # };
      config = {
        # theme = "Catppuccin Mocha";
        # Don't show none of them fancy pants line numbers or such 🤠
        plain = true;
      };
    };
  };
}
