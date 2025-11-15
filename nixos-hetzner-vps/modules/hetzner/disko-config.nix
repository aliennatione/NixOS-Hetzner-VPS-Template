#
# This file defines the declarative disk partitioning for Hetzner Cloud servers.
# It uses the `disko` library to create a reproducible disk layout.
# This configuration is automatically applied by `nixos-anywhere` during installation.
#
{
  disko.devices = {
    # Define a single disk device.
    disk = {
      # The `vda` name is an internal identifier for disko.
      vda = {
        type = "disk";
        # Hetzner Cloud VMs can use `/dev/sda` or `/dev/vda` depending on the virtualization.
        # disko will automatically detect and use the correct one.
        device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-0"; # Most reliable way to identify the disk
        content = {
          type = "gpt"; # Use GUID Partition Table (GPT)
          partitions = {
            # 1. ESP (EFI System Partition)
            #    Required for UEFI boot.
            ESP = {
              size = "512M";
              type = "EF00"; # Partition type for EFI System
              content = {
                type = "filesystem";
                format = "vfat"; # FAT32 filesystem
                mountpoint = "/boot"; # Mount it at /boot
              };
            };

            # 2. Root Partition
            #    This partition will hold the entire NixOS installation.
            root = {
              size = "100%"; # Use the rest of the disk space
              content = {
                type = "filesystem";
                format = "ext4"; # Use the ext4 filesystem
                mountpoint = "/"; # Mount it as the root filesystem
              };
            };
          };
        };
      };
    };
  };
}
