{ config, lib, ... }:
{
  options.muradb.ssh = {
    authorizedKeys = lib.mkOption {
      type = with lib.types; listOf str;
      default = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOIHAvKIcVIdmEoANP4iTnzac7sAQVvVIDFSPuxfpMws"
      ];
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 22;
    };
  };
  config = {
    # Endless SSH honeypot
    services.endlessh = {
      enable = true;
      port = 22;
      openFirewall = true;
    };

    # actual OpenSSH daemon
    services.openssh = {
      enable = true;
      ports = [ config.muradb.ssh.port ];
      openFirewall = true;

      # allow root login for remote deploy aka. rebuild-switch
      settings.AllowUsers = [
        "muradb"
        "root"
      ]
      ++ lib.ifEnable config.muradb.gitserver.enable [ "git" ];
      settings.PermitRootLogin = "yes";

      # require public key authentication for better security
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
    };

    users.users."muradb".openssh.authorizedKeys.keys = config.muradb.ssh.authorizedKeys;
    users.users."root".openssh.authorizedKeys.keys = config.muradb.ssh.authorizedKeys;

    # run 'screenfetch' command on SSH logins
    programs.bash.interactiveShellInit = "screenfetch";
  };
}
