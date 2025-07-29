{
  config,
  lib,
  ...
}: let
  cfg = config.custom.system.locale;
in {
  options.custom.system.locale.enable = lib.mkEnableOption "Enable locale settings";

  config = lib.mkIf cfg.enable {
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };
  };
}
