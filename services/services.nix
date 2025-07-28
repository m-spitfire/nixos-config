{
  imports = [
    ./gitserver.nix
    ./ssh.nix
    ./caddy.nix
    ./vaultwarden.nix
    ./auth
    ./postgresql.nix
    ./redis.nix
    ./actual.nix
    ./memos.nix
  ];
}
