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
      config = {
        plain = true;
      };
    };
  };
}
