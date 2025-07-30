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

  environment.systemPackages = with pkgs; [
    curl
    btop
    dnsutils
    nil
    just
    unixtools.netstat
    screenfetch
    git
    vim
    neovim
    tldr
    zip
    unzip
    wget
    ripgrep
    bottom
    htop
    jq
    openldap
    tmux
  ];

  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;
  system.stateVersion = "25.05";
}
