partitions = {
  ESP = {
    priority = 1;
    size = "2G";
    type = "EF00";
    content = {
      type = "filesystem";
      format = "vfat";
      mountpoint = "/boot";
      mountOptions = [ "umask=0077" ];
    };
  };
  nixos = {
    priority = 2;
    size = "100%";
    content = {
      type = "filesystem";
      format = "ext4";
      mountpoint = "/";
    };
  };
};