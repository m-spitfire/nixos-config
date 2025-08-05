{
  config,
  lib,
  ...
}: let
  cfg = config.custom.programs.starship;
in {
  options.custom.programs.starship.enable = lib.mkEnableOption "Enable Starship prompt";

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        ## Top level configuration
        # Don't print a new line at the start of the prompt
        add_newline = false;
        # Left prompt
        format = lib.concatStrings [
          "$directory"
          "$shlvl"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_status"
          "$jobs"
          "$status"
          "$container"
          "$nix_shell"
          "$shell"
          "$character"
        ];
        # Right prompt
        right_format = lib.concatStrings [
          "$hostname"
        ];

        ## Module configuration
        character = {
          success_symbol = "[❯](green)";
          error_symbol = "[❯](red)";
        };
        directory = {
          format = "[$path]($style) [$read_only]($read_only_style)";
          read_only = " ";
          fish_style_pwd_dir_length = 3;
          truncation_length = 3;
        };
        git_branch = {
          format = "[$branch(:$remote_branch)]($style) ";
          style = "green";
        };
        git_status = {
          format = "([$all_status$ahead_behind]($style) )";
          # Component formatting
          ahead = "⇡\${count}";
          behind = "⇣\${count}";
          diverged = "⇡\${ahead_count}⇣\${behind_count}";
          modified = "!\${count}";
          deleted = " ";
          stashed = "*";
          style = "bold yellow";
        };
        nix_shell = {
          format = "[$symbol]($style)";
          symbol = "󱄅 ";
          heuristic = true;
        };
        shell = {
          bash_indicator = "#";
          fish_indicator = "";
          nu_indicator = "";
          format = "[$indicator]($style)";
          style = "bold purple";
          disabled = false;
        };
        hostname = {
          format = "[$hostname $ssh_symbol]($style)";
          ssh_symbol = " ";
          style = "yellow";
        };
      };
    };
  };
}
