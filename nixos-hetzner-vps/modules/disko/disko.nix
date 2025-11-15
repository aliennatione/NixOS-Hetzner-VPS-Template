{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda"; # Standard disk name in Hetzner Cloud
        content = {
          type = "gpt";
          partitions = {
            # Boot partition
            boot = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            # Root partition
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
