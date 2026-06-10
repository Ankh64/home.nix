{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.mosh.enable = true;
  services.tailscale.enable = true;
  services.tailscale.extraDaemonFlags = [ "--no-logs-no-support" ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/persistent/etc/nixos/";
  };

  systemd.services = {
    disable-wifi-powersave = {
      description = "Disable Wi-Fi Power Saving for wlp2s0";
      after = [
        "network.target"
        "wpa_supplicant.service"
      ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.iw ];
      script = ''
        # Wait a few seconds for the interface to fully initialize
        sleep 10
        echo "Disabling power saving on wlp2s0..."
        iw dev wlp2s0 set power_save off
      '';
    };
  };
  security.polkit.enable = true;

  services.asusd.enable = true;
  security.sudo.extraConfig = "Defaults env_reset,pwfeedback";
  boot.extraModprobeConfig = ''
    options iwlwifi power_save=0
    options iwlmvm power_scheme=1
  '';
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nix"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  services.logind.settings.Login.HandleLidSwitch = "ignore";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.adi = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    # initialPassword = "letmein";
    hashedPassword = "$6$rounds=40000$Wx6ha4zrwDVDDSoe$QCf78yMjK6ZUx8e5ACG584WJuIu2t6LIVgwCwhhTcFkHy8gsAQ.7m1F8I9rLRR4NL7du/VLvAFZXD1UDXyXEW/";
    packages = with pkgs; [
      tree
      wget
      wayvnc
      xwayland
      wlr-randr
    ];
    linger = true;
    shell = pkgs.zsh;
  };
  systemd.user.services.sway-vnc = {
    description = "Sway compositor with wayvnc";
    after = [ "default.target" ];
    # NOT wantedBy anything — so it does NOT start on boot

    environment = {
      WLR_BACKENDS        = "headless";
      WLR_LIBINPUT_NO_DEVICES = "1";   # no input devices on headless
      XDG_RUNTIME_DIR     = "/run/user/1000";  # adjust UID if needed
      WAYLAND_DISPLAY     = "wayland-1";
    };

    serviceConfig = {
      Type       = "simple";
      ExecStartPre = "${pkgs.sway}/bin/sway --version"; # sanity check
      ExecStart  = pkgs.writeShellScript "sway-vnc-start" ''
        # Start sway in headless mode in the background
        ${pkgs.sway}/bin/sway &
        SWAY_PID=$!

        # Wait for the Wayland socket to appear
        sleep 2

        # Create a virtual output (1920x1080 headless display)
        ${pkgs.wlr-randr}/bin/wlr-randr --output HEADLESS-1 --mode 1920x1080

        # Start wayvnc on all interfaces, port 5900
        ${pkgs.wayvnc}/bin/wayvnc 0.0.0.0 5900

        wait $SWAY_PID
      '';
      ExecStopPost = "${pkgs.procps}/bin/pkill wayvnc || true";
      Restart    = "no";
    };
  };

  
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    lm_sensors
    nushell
    sway
    ghostty.terminfo
  ];

  services.openssh = {
    enable = true;
    extraConfig = ''
      AcceptEnv COLORTERM TERM
    '';
    settings.X11Forwarding = true;
  };
  networking.firewall.allowedTCPPorts = [ 5900 ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "26.05";
}
