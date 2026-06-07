{ pkgs, ... }:
{
  import = [
    ./zellij.nix
    ./helix.nix
  ];
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
  programs.btop = {
    enable = true;
    settings.color_theme = "everforest-dark-hard";
    settings.theme_background = false;
  };

  programs.zoxide.enable = true;
  programs.direnv = {
    enable = true;
    silent = true;
    enableFishIntegration = true;
  };
  programs.nnn = {
    enable = true;
    enableFishIntegration = true;
    package = pkgs.nnn.override { withNerdIcons = true; };
    bookmarks = {
      d = "~/Documents";
    };
  };
  programs.starship.enable = true;
  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };
  
  programs.eza.enable = true;
 
  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
  };
}
