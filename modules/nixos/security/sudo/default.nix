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

  cfg = config.custom.security.sudo;
in {
  options.custom.security.sudo.enable = mkEnableOption "sudo tweaks";

  config = mkIf cfg.enable {
    security.sudo = {
      extraConfig = ''
        # Show asterix when typing password
        Defaults pwfeedback
        # Keep our SYSTEMD_EDITOR variable
        Defaults env_keep += "EDITOR"
        # No lectures >:(
        Defaults lecture = never
      '';
    };
  };
}
