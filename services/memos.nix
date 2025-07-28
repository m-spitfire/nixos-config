{ lib
, pkgs
, config
, ...
}:

let
  inherit (lib)
    mkOption
    types
    mkPackageOption
    mkEnableOption
    mkIf
    ;

  defaultUser = "memos";
  defaultGroup = defaultUser;
  defaultSpaceDir = "/var/lib/memos";
  cfg = config.services.memos;
in
{
  options.services.memos = {
    package = mkPackageOption pkgs "memos" { };
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
    #environmentFile = mkOption {
    #  type = types.either types.str types.path;
    #};
    port = mkOption {
      type = types.port;
    };
    spaceDir = lib.mkOption {
      type = lib.types.path;
      default = defaultSpaceDir;
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = defaultGroup;
    };
  };

  config = {
    environment.systemPackages = [ cfg.package ];

    systemd.services.memos = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "memos daemon";
      preStart = lib.mkIf (!lib.hasPrefix "/var/lib/" cfg.spaceDir) "mkdir -p '${cfg.spaceDir}'";
      serviceConfig = {
        Type = "simple";
        User = "${cfg.user}";
        Group = "${cfg.group}";
        ExecStart = "${lib.getExe cfg.package} --mode ${cfg.mode} --port ${toString cfg.port} --instance-url ${cfg.instanceUrl} --data ${cfg.spaceDir}";
        #EnvironmentFile = cfg.environmentFile;
        StateDirectory = lib.mkIf (lib.hasPrefix "/var/lib/" cfg.spaceDir) (
          lib.last (lib.splitString "/" cfg.spaceDir)
        );
        Restart = "on-failure";
      };
    };
    users.users.${defaultUser} = lib.mkIf (cfg.user == defaultUser) {
      isSystemUser = true;
      group = cfg.group;
      description = "Memos daemon user";
    };
    users.groups.${defaultGroup} = lib.mkIf (cfg.group == defaultGroup) { };

    services.memos = {
      instanceUrl = "https://memos.000376.xyz";
      port = 5550;
      mode = "dev";
      #environmentFile = age.secrets."deep_memos_env".path;
    };
    services.caddy.virtualHosts."${cfg.instanceUrl}".extraConfig = ''
      	  reverse_proxy 127.0.0.1:${toString cfg.port}
      	'';
  };
}
