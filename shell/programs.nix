{ pkgs, ... }:
{
  imports = [
    ./zellij.nix
    ./helix.nix
  ];

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
   nix-direnv.enable = true;
  };

  programs.nnn = {
    enable = true;
    enableFishIntegration = true;
    package = pkgs.nnn.override { withNerdIcons = true; };
    bookmarks = {
      d = "~/Documents";
    };
  };

  programs.starship = {
    enable = true;
    enableTransience = true;
  };
  home.file = {
    ".config/starship.toml".source = ./starship.toml;
  };
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
  programs.ripgrep.enable = true;
}
