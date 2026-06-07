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

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Aditya";
        email = "85212821+Ankh64@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
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
  services.asusd.enable = true;

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
    #initialPassword = "letmein";
    hashedPassword = "$6$rounds=40000$Wx6ha4zrwDVDDSoe$QCf78yMjK6ZUx8e5ACG584WJuIu2t6LIVgwCwhhTcFkHy8gsAQ.7m1F8I9rLRR4NL7du/VLvAFZXD1UDXyXEW/";
    packages = with pkgs; [
      tree
      wget
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    lm_sensors
    nushell
    ghostty.terminfo
  ];

  services.openssh = {
    enable = true;
    extraConfig = ''
      AcceptEnv COLORTERM TERM
    '';
  };
  networking.firewall.allowedTCPPorts = [ 8082 ];
  system.copySystemConfiguration = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "26.05";
}
