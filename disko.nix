{
  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persistent".neededForBoot = true;
  disko.devices.nodev = {
    "/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=25%"
        "mode=755"
      ];

    };

  };

  disko.devices.disk.main = {
    device = "dev/sda";
    type = "disk";

    content.type = "gpt";

    content.partitions = {
      boot = {
        name = "boot";
        size = "5M";
        type = "EF02";
      };
      esp = {
        name = "ESP";
        size = "512M";
        type = "EF00";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
        };
      };
      swap = {
        size = "8G";
        content = {
          type = "swap";
          resumeDevice = true;
        };
      };
      root = {
        name = "root";
        size = "100%";

        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];

          subvolumes = {
            "/persistent" = {
              mountOptions = [
                "subvol=persist"
                "noatime"
              ];
              mountpoint = "/persistent";
            };
            "/nix" = {
              mountOptions = [
                "subvol=nix"
                "noatime"
              ];
              mountpoint = "/nix";
            };
          };
        };
      };
    };

  };

}
