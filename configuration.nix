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
  nixpkgs.config.allowUnfree = true;
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
      i3
      xterm
      tigervnc
    ];
    linger = true;
    shell = pkgs.zsh;
  };
  systemd.user.services.start-vnc = {
    description = "i3 desktop over VNC";
    after = [ "default.target" ];
    # still not started on boot — manual only
    path = with pkgs; [
      i3
      tigervnc
    ];
    serviceConfig = {
      Type = "simple";
      ExecStart = pkgs.writeShellScript "start-vnc" ''
  # Start Xvnc in background
  ${pkgs.tigervnc}/bin/Xvnc :1 \
    -geometry 1920x1080 \
    -depth 24 \
    -rfbport 5900 \
    -SecurityTypes None \
    -localhost no &
  
  # Wait for X socket to appear
  for i in $(seq 1 20); do
    [ -S /tmp/.X11-unix/X1 ] && break
    sleep 0.5
  done

  if [ ! -S /tmp/.X11-unix/X1 ]; then
    echo "Xvnc never started"
    exit 1
  fi

  # Now start i3
  DISPLAY=:1 ${pkgs.i3}/bin/i3
'';};
  };

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    lm_sensors
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
