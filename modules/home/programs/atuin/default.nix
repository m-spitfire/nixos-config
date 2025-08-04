{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe
    getExe'
    mkEnableOption
    mkIf
    ;

  inherit (config.sops) secrets;

  cfg = config.custom.programs.atuin;
  user = config.snowfallorg.user.name;
in {
  options.custom.programs.atuin.enable = mkEnableOption "Enable atuin";

  config = mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      settings = {
        key_path = secrets."common/users/${user}/atuin/key".path;
        # Enable sync v2 by default
        sync.records = true;
        # Immediately execute a command without having to press Enter twice
        enter_accept = true;
        # Only search history from current directory for Up key
        filter_mode_shell_up_key_binding = "host";
      };
    };

    # Automatically login if not already logged in
    systemd.user.services.atuin-login = {
      Unit = {
        Description = "Automatically login to Atuin if not already logged in";
        After = ["sops-nix.service"];
      };
      Install.WantedBy = ["default.target"];
      Service = {
        Type = "oneshot";
        ExecStart = let
          cat = getExe' pkgs.coreutils "cat";
        in
          pkgs.writeShellScript "atuin-login" ''
            ${getExe pkgs.atuin} login \
                -k $(${cat} ${secrets."common/users/${user}/atuin/key".path}) \
                -p $(${cat} ${secrets."common/users/${user}/atuin/password".path}) \
                -u $(${cat} ${secrets."common/users/${user}/atuin/username".path})
          '';
      };
    };

    sops.secrets = {
      "common/users/${user}/atuin/key" = {};
      "common/users/${user}/atuin/password" = {};
      "common/users/${user}/atuin/username" = {};
    };
  };
}
