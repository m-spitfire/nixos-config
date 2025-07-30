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
      hashedPasswordFile = config.sops.secrets."common/users/muradb/password".path;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };
    sops.secrets."common/users/muradb/password".neededForUsers = true;
  };
}
