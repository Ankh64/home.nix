{}:
{
  programs.zellij = {
    enable = true;
    extraConfig = ''
      pane_frames true 
      default_layout "compact"
      session_serialization false
      show_startup_tips false
      show_release_notes false
      visual_bell false
      theme "everforest-dark"
      ui {
          pane_frames {
              rounded_corners true
          }
      }

      copy_command "wl-copy"
      keybinds {
        normal {
          bind "Alt c" { Copy; }
        }
        scroll {
          bind "Alt c" { Copy; }
        }
      }

    '';
  };
}
