{ config, pkgs, ... }:
{
  home.username = "adi";
  home.homeDirectory = "/home/adi";
  imports = [
    ./shell/shell.nix
  ];
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    nixfmt
    nil
    jujutsu
  ];
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];
  programs.home-manager.enable = true;
  home.sessionVariables = {
    COLORTERM = "truecolor";
    TERM = "xterm-256color";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
  };


}
