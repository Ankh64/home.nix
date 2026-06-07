{...}:
{
 programs.starship = {
    enable = true;
    enableTransience = true;
  };
  home.file = {
    ".config/starship.toml".source = ./starship.toml;
  };
}
