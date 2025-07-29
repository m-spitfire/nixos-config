{
  config,
  inputs,
  lib,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    snowfall
    ;

  cfg = config.custom.security.secrets;
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  options.custom.security.secrets.enable = mkEnableOption "secret management";

  config = mkIf cfg.enable {
    # Secret management
    sops = {
      defaultSopsFile = snowfall.fs.get-file "secrets.yaml";
      defaultSopsFormat = "yaml";
      age = {
        # This is the default AGE key that will be used for bootstrapping the system
        keyFile = "/var/lib/sops-nix/key.txt";
      };
    };
  };
}
