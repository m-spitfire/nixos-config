{
  lib,
  modulesPath,
  config,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd = {
      kernelModules = [];
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
      ];
    };
    kernelModules = [];
    extraModulePackages = [];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/38fedab4-99e0-4752-9310-f3f151ec3700";
    fsType = "ext4";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/62278448-254e-46d0-be0c-1c7ce574ce11";}];

  sops.secrets."deep/storage-box/ssh-key" = {};

  fileSystems."/mnt/storagebox" = {
    device = "u490600@u490600.your-storagebox.de:/";
    fsType = "fuse.sshfs";
    options = [
      # BASIC CONNECTION
      "allow_other" # Allow other users to access mount
      "reconnect" # Auto-reconnect on connection loss
      "ServerAliveInterval=15" # Send keepalive every 15 seconds
      "ServerAliveCountMax=3" # Drop connection after 3 failed keepalives

      # PERFORMANCE & CACHING
      "cache=yes" # Enable attribute and data caching
      "kernel_cache" # Use kernel page cache for better performance
      "compression=no" # Disable SSH compression (faster on good connections)
      "noatime" # Improve performance by disabling atime updates

      # BUFFER SIZES
      "max_read=131072" # 128KB read buffer (good for streaming)
      "max_write=131072" # 128KB write buffer (good for downloads)

      # SSH CONNECTION OPTIMIZATION
      "BatchMode=yes" # Non-interactive mode
      "TCPKeepAlive=yes" # Enable TCP keepalive
      "ControlMaster=auto" # Reuse SSH connections when possible
      "ControlPath=/tmp/sshfs-%r@%h:%p" # Socket path for connection sharing
      "ControlPersist=600" # Keep connection alive for 10 minutes after last use

      # SYMLINK HANDLING
      "follow_symlinks" # Follow symlinks on remote side
      "transform_symlinks" # Convert absolute symlinks to relative

      # SYSTEMD INTEGRATION
      "_netdev" # Mark as network filesystem
      "x-systemd.after=network-online.target" # Wait for network
      "x-systemd.wants=network-online.target" # Require network target
      "nofail"  # Don't fail boot if mount fails

      # AUTHENTICATION
      "IdentityFile=${config.sops.secrets."deep/storage-box/ssh-key".path}"
      "StrictHostKeyChecking=no" # Skip host key verification (use carefully)
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
