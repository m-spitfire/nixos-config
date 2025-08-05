_: let
  sshAuthKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOIHAvKIcVIdmEoANP4iTnzac7sAQVvVIDFSPuxfpMws"
  ];
in {
  # Endless SSH honeypot
  services.endlessh = {
    enable = true;
    port = 22;
    openFirewall = true;
  };

  # actual OpenSSH daemon
  services.openssh = {
    enable = true;
    ports = [23459];
    openFirewall = true;

    # allow root login for remote deploy aka. rebuild-switch
    settings.AllowUsers = [
      "muradb"
      "root"
    ];
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users."muradb".openssh.authorizedKeys.keys = sshAuthKeys;
  users.users."root".openssh.authorizedKeys.keys = sshAuthKeys;
}
