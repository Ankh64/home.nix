{
  #systemd.services.systemd-machine-id-commit = {
  #	unitConfig.ConditionPathIsMountPoint = [ "" "/etc/machine-id" ];
  #};
  #systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ]
  # Point /etc/machine-id directly to your persistent storage file as a symlink
  #environment.etc."machine-id".source = "/persistent/etc/machine-id";
  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/persistent/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /persistent"
    ];
  };
  boot.tmp.cleanOnBoot = true;
  preservation = {
    enable = true;

    preserveAt."/persistent" = {
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_rsa_key";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_rsa_key.pub";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key.pub";
          how = "symlink";
          configureParent = true;
        }
      ];
      directories = [
        "/var/lib/systemd/timers"
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
          "/var/lib/tailscale"
        "/var/log"
        "/etc/NetworkManager/system-connections"
      ];
      users.adi = {
        files = [
          ".histfile"
          ".zsh_history"
          ".bootdev.yaml"
        ];
        directories = [
          {
            directory = ".ssh";
            mode = "0700";
          }
          "Documents"
          ".local"
          ".config"
        ];
      };
      users.root = {
        home = "/root";
        directories = [
          {
            directory = ".ssh";
            mode = "0700";
          }
        ];
      };
    };
  };
  systemd.tmpfiles.settings.preservation = {
    "/home/adi/.config".d = {
      user = "adi";
      group = "users";
      mode = "0755";
    };
    "/home/adi/.local".d = {
      user = "adi";
      group = "users";
      mode = "0755";
    };
  };
}
