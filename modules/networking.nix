{ config, ... }:
{
  networking.networkmanager.enable = true;

  # open firewall ports
  networking.firewall =
    let
      port = config.muradb.ssh.port;
    in
    {
      allowedTCPPorts = [ port ];
      allowedUDPPorts = [ port ];
    };
}
