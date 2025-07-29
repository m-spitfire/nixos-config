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

  cfg = config.custom.suites.common;
in {
  options.custom.suites.common.enable = mkEnableOption "common settings";

  config = mkIf cfg.enable {
    custom = {
      nix.enable = true;
      services = {
        envfs.enable = true;
        ld.enable = true;
      };
      security = {
        secrets.enable = true;
        sudo.enable = true;
      };
      system = {
        boot.loader = true;
        locale.enable = true;
      };
      users.enable = true;
    };
  };
}
