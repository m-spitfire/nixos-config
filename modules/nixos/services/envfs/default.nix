{
  config,
  lib,
  ...
}: let
  cfg = config.custom.services.envfs;
in {
  options.custom.services.envfs.enable = lib.mkEnableOption "Enable EnvFS";

  config = lib.mkIf cfg.enable {
    # Dynamically populates contents of /bin and /usr/bin, allowing
    # programs that assume FHS to work.
    services.envfs.enable = true;
  };
}
