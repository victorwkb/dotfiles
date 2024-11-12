{ pkgs, ... }:
{
  enable = true;
  baseIndex = 1;
  disableConfirmationPrompt = true;
  keyMode = "vi";
  newSession = true;
  secureSocket = true;
  shell = "${pkgs.zsh}/bin/zsh";
  shortcut = "a";
  escapeTime = 0;

  plugins = with pkgs.tmuxPlugins; [
    {
      plugin = catppuccin;
      extraConfig = ''
        # run nushell through zsh (not as login shell)
        set -g default-command "exec nu"

        # Catppuccin theme
        set -g @catppuccin_flavor 'macchiato'
        set -g @catppuccin_window_status_style "rounded"
        set -g @catppuccin_window_left_separator ""
        set -g @catppuccin_window_right_separator " "
        set -g @catppuccin_window_middle_separator " █"
        set -g @catppuccin_window_number_position "right"
        set -g @catppuccin_window_number_color "number"
        set -g @catppuccin_window_text_color "#W"
        set -g @catppuccin_window_current_number_color "number"
        set -g @catppuccin_window_current_text_color "#W#{?window_zoomed_flag,(),}"
        set -g @catppuccin_status_modules_right "directory date_time"
        set -g @catppuccin_status_modules_left "session"
        set -g @catppuccin_status_left_separator  " "
        set -g @catppuccin_status_right_separator " "
        set -g @catppuccin_status_right_separator_inverse "no"
        set -g @catppuccin_status_fill "icon"
        set -g @catppuccin_status_connect_separator "no"
        set -g @catppuccin_directory_text "#{b:pane_current_path}"
        set -g @catppuccin_date_time_text "%H:%M"
        set -g @catppuccin_status_background "default"
      '';
    }
    {
      plugin = continuum;
      extraConfig = "set -g @continuum-restore 'on'";

    }
    {
      plugin = resurrect;
      extraConfig = "set -g @resurrect-capture-pane-contents 'on'";
    }
    sensible
    yank
  ];

  extraConfig = ''
    # fast reload
    unbind r
    bind r source-file $HOME/.config/tmux/tmux.conf

    # window splitting
    unbind %
    bind | split-window -h
    unbind '"'
    bind - split-window -v

    set -g mouse on

    set -g detach-on-destroy off
    set-option -g focus-events on
    bind -T copy-mode-vi v send-keys -X begin-selection
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
    bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy | tmux load-buffer - && tmux paste-buffer"

    # vim-like pane switching
    bind -r ^ last-window
    bind -r h select-pane -L
    bind -r j select-pane -D
    bind -r k select-pane -U
    bind -r l select-pane -R
    bind -r m resize-pane -Z

    # tpm plugin
    # set -g @plugin 'tmux-plugins/tpm'

    # tmux sessionizer
    bind -n C-f run-shell "tmux neww ~/dotfiles/.config/bin/.local/scripts/tmux-sessionizer"
    bind -r f run-shell "tmux neww ~/dotfiles/.config/bin/.local/scripts/tmux-sessionizer"
  '';
}
