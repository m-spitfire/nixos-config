_: {
  imports = [
    ./navidrome.nix
    ./slskd.nix
  ];
  users = {
    # This user owns /media/data
    users.media = {
      group = "media";
      isSystemUser = true;
    };
    groups.media = {};
  };
}
