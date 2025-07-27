[
  {
    name = "deep";
    system = "x86_64-linux";
    nixosModules = [
      ./hardware/hetzner-vm.nix
      {
        muradb = {
          gitserver.enable = true;
          ssh.port = 23459;
        };

        networking.hostName = "deep";
        system.stateVersion = "25.05";
      }
    ];
  }
]
