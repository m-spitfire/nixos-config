{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe
    getExe'
    mkEnableOption
    mkIf
    ;

  cfg = config.custom.programs.fish;
in {
  options.custom.programs.fish.enable = mkEnableOption "fish";

  config = mkIf cfg.enable {
    programs = {
      fish = {
        enable = true;
        plugins = with pkgs.fishPlugins; [
          {
            name = "done";
            src = done;
          }
        ];
        interactiveShellInit = ''
          # Use fish for `nix shell` and `nix develop`
          ${getExe pkgs.nix-your-shell} fish | source

          fish_vi_key_bindings
          set fish_cursor_default block
        '';
      };
      # Setting fish as our default shell causes some issues. Instead, automatically launch fish
      # when we start an interactive bash shell, but only if we're not opening one from fish.
      bash = {
        enable = true;
        initExtra =
          # bash
          ''
            if [[ $(${getExe' pkgs.procps "ps"} --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]; then
                shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
                exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
            fi
          '';
      };
    };

    # Environment variables
    home.sessionVariables = {
      # The fish greeting is annoying 😡🤜🐟
      fish_greeting = "";
    };
  };
}
