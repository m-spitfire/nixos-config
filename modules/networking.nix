{ config, ... }:
{
  networking.networkmanager.enable = true;

  # open firewall ports
  networking.firewall =
    let
      sshPort = config.muradb.ssh.port;
    in
    {
      allowedTCPPorts = [
        sshPort
        80
        443
      ];
      allowedUDPPorts = [ sshPort ];
    };
}
