{
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/muradb/nixos-config";
  };
}
