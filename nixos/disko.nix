{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1"; # Change to your actual disk (e.g., /dev/sda)
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # Shared EFI System Partition
            ESP = {
              priority = 1;
              size = "2G"; # Generous size for hosting multiple kernels
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            # NixOS Root Partition
            nixos = {
              priority = 2;
              size = "200G"; # Allocate a fixed size for NixOS
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            # Arch Linux Partition (Disko creates it, but doesn't mount it)
            arch = {
              priority = 3;
              size = "100%"; # Takes up all remaining space on the disk
              content = {
                type = "filesystem";
                format = "ext4";
                # No mountpoint defined so NixOS installation ignores it
              };
            };
          };
        };
      };
    };
  };
}
