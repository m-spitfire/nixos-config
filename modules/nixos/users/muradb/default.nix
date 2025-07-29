{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    optionals
    ;

  cfg = config.custom.users.muradb;
in {
  options.custom.users.muradb.enable = mkEnableOption "Murad user";

  config = mkIf cfg.enable {
    users.users.muradb = {
      isNormalUser = true;
      description = "Murad";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };
  };
}
