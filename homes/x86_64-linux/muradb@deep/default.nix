{
  pkgs,
  config,
  ...
}: {
  custom = {
    suites = {
      common.enable = true;
    };
  };
  home.stateVersion = "25.05";
}
