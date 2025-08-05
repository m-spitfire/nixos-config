{
  config,
  lib,
  ...
}: let
  cfg = config.custom.programs.tmux;
in {
  options.custom.programs.tmux.enable = lib.mkEnableOption "Enable tmux";

  config = lib.mkIf cfg.enable {
    stylix.targets.tmux.enable = true;
    programs.tmux = {
      enable = true;
      prefix = "C-p";
      terminal = "tmux-256color";
      baseIndex = 1;
      keyMode = "vi";
      historyLimit = 10000;
      escapeTime = 100;
      extraConfig = ''
        set-option -ga terminal-overrides ",alacritty:RGB"

        # don't let programs rename windows when inside a tmux env
        %if #{TMUX_ENV}
        set-option -w -g allow-rename off
        set-option -w -g automatic-rename off
        %else
        set-option -w -g allow-rename on
        set-option -w -g automatic-rename on
        set-option -w -g automatic-rename-format '#{pane_current_command}'
        %endif

        # store OSC 52 content as buffer and to terminal clipboard
        set-option -g set-clipboard on

        # use session name as terminal window title
        set-option -g set-titles on
        set-option -g set-titles-string '#{session_name} / #{window_name}'

        # don't detach the client when killing a session
        # only inside a tmux env
        %if #{TMUX_ENV}
        set-option -g detach-on-destroy off
        %else
        set-option -g detach-on-destroy on
        %endif

        # close windows/panes when initial command exits
        set-option -w -g remain-on-exit off

        # define characters considered not part of a word
        # remove "all" non alphanumeric characters, except _
        set-option -g word-separators "!\"#$%&'()*+,-./:;<=>?@[\\]^`{|}~ "

        # automatically renumber windows when one gets closed
        set-option -g renumber-windows on

        # define time panes indicator are shown when using display-panes
        set-option -g display-panes-time 1500

        # define time messages and indicators are shown
        set-option -g display-time 3000

        # decrease the binding keys repeat time
        set-option -g repeat-time 300

        # do not monitor activity/bell/silence by default
        set-option -w -g monitor-activity off
        set-option -w -g monitor-bell off
        set-option -w -g monitor-silence 0

        # disable default visual display of activity/bell/silence alerts
        set-option -g visual-activity off
        set-option -g visual-bell off
        set-option -g visual-silence off

        # run activity/bell/silence actions from any window
        # preferably we'd use it only for other windows than current one
        # but then no action would be triggered on active window from another session
        set-option -g activity-action any
        set-option -g bell-action any
        set-option -g silence-action any
      '';
    };
  };
}
