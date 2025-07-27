{ pkgs, agenix, ... }:
{
  users.users.muradb = {
    isNormalUser = true;
    description = "Murad";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      curl
      btop
      dnsutils
      nil
      unixtools.netstat
    ];
  };
  environment.systemPackages = with pkgs; [
    screenfetch
    agenix
    git
    vim
    tldr
    zip
    unzip
    wget
    ripgrep
  ];
}
