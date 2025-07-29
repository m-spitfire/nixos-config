{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.custom.system.boot;
in {
  options.custom.system.boot = {
    loader = mkEnableOption "boot settings";
  };

  config = mkIf cfg.loader {
    boot.loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
  };
}
