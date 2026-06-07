{ config, ... }:
{
  imports = [
    ./programs.nix
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellAliases = {
      ez = "eza --icons";
    };
    functions = {
      starship_transient_prompt_func = {
        body = ''
          starship module character
        '';
      };
      n = {
        description = "nnn wrapper with quitcd";
        body = ''
          if test -n "$NNNLVL" -a "$NNNLVL" -ge 1
              echo "nnn is already running"
              return
          end

          if test -n "$XDG_CONFIG_HOME"
              set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
          else
              set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
          end

          command nnn $argv

          if test -e $NNN_TMPFILE
              source $NNN_TMPFILE
              rm -- $NNN_TMPFILE
          end
        '';
      };
      devinit = {
        body = ''
          nix flake new -t github:nix-community/nix-direnv .
          echo "use nix" > .envrc
          direnv allow
        '';
      };
      zj = {
        description = "Start a Zellij session";
        body = ''
          if test (count $argv) -eq 0
              echo "Please provide a session name."
              return 1
          end
          zellij -s $argv[1]
        '';
      };
      za = {
        description = "Attach to a Zellij session";
        body = ''
          if test (count $argv) -eq 0
              zellij attach; or echo "Create a new session"
          else
              zellij attach $argv[1]; or zellij list-sessions
          end
        '';
      };
      zrm = {
        description = "Kill a Zellij session";
        body = ''
          if test (count $argv) -eq 0
          echo "Please provide a session name."
          return 1
          end
          zellij d $argv[1] --force
          zellij ls
        '';
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    history.path = "${config.home.homeDirectory}/.zsh_history";
    initContent = ''
      if [[ $- == *i* ]]; then
        exec fish
      fi
    '';
  };

}
