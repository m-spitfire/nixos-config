{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/38fedab4-99e0-4752-9310-f3f151ec3700";
    fsType = "ext4";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/62278448-254e-46d0-be0c-1c7ce574ce11";}];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
