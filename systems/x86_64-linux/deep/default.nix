{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware.nix
    ./services
  ];
  custom = {
    suites = {
      common.enable = true;
    };
    users.muradb.enable = true;
  };

  time.timeZone = "Europe/Berlin";

  programs.neovim.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    openldap
    git
  ];

  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;
  system.stateVersion = "25.05";
}
