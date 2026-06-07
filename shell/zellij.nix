{ ... }:
{
  programs.zellij = {
    enable = true;
    extraConfig = ''
      pane_frames false
      default_layout "compact"
      session_serialization false
      show_startup_tips false
      show_release_notes false
      visual_bell false
      theme "everforest-dark"
      simplified_ui true

      keybinds {
        normal {
          bind "Alt c" { Copy; }
        }
        scroll {
          bind "Alt c" { Copy; }
        }
        move {
          bind "n" { MovePane; }
          bind "Tab" { NextSwapLayout; }
        }
      }

    '';
  };
}
