{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    mkPackageOption
    mkEnableOption
    mkIf
    ;

  defaultUser = "memos";
  defaultGroup = defaultUser;
  defaultSpaceDir = "/var/lib/memos";
  cfg = config.custom.services.memos;
in {
  options.custom.services.memos = {
    enable = mkEnableOption "Memos";
    package = mkPackageOption pkgs "memos" {};
    instanceUrl = mkOption {
      type = types.str;
    };
    mode = mkOption {
      type = types.enum [
        "prod"
        "dev"
        "demo"
      ];
    };
    envFile = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
    port = mkOption {
      type = types.port;
    };
    spaceDir = mkOption {
      type = types.path;
      default = defaultSpaceDir;
    };
    user = mkOption {
      type = types.str;
      default = defaultUser;
    };
    group = mkOption {
      type = types.str;
      default = defaultGroup;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    systemd.services.memos = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "memos daemon";
      preStart = lib.mkIf (!lib.hasPrefix "/var/lib/" cfg.spaceDir) "mkdir -p '${cfg.spaceDir}'";
      serviceConfig = {
        Type = "simple";
        User = "${cfg.user}";
        Group = "${cfg.group}";
        ExecStart = "${lib.getExe cfg.package} --mode ${cfg.mode} --port ${toString cfg.port} --instance-url ${cfg.instanceUrl} --data ${cfg.spaceDir}";
        EnvironmentFile = lib.mkIf (cfg.envFile != null) "${cfg.envFile}";
        StateDirectory = lib.mkIf (lib.hasPrefix "/var/lib/" cfg.spaceDir) (
          lib.last (lib.splitString "/" cfg.spaceDir)
        );
        Restart = "on-failure";
      };
    };
    users.users.${defaultUser} = lib.mkIf (cfg.user == defaultUser) {
      isSystemUser = true;
      inherit (cfg) group;
      description = "Memos daemon user";
    };
    users.groups.${defaultGroup} = lib.mkIf (cfg.group == defaultGroup) {};
  };
}
