{
  config,
  lib,
  ...
}: let
  cfg = config.custom.programs.git;
in {
  options.custom.programs.git.enable = lib.mkEnableOption "Enable git";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Murad Bashirov";
      userEmail = "carlsonmu@gmail.com";
      lfs.enable = true;
      # Makes diffs easier to read
      difftastic.enable = true;
      signing = {
        key = "057D8CEB91DDE3FA";
        signByDefault = true;
      };
      extraConfig = {
        core.autocrlf = "false";
        color.ui = true;
        column.ui = "auto";
        branch.sort = "-committerdate";
        tag.sort = "version:refname";
        init.defaultBranch = "master";
        merge.conflictstyle = "diff3";
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicPrefix = true;
          renames = true;
        };
        push = {
          default = "simple";
          autoSetupRemote = true;
          followTags = true;
        };
        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
        };
      };
    };
  };
}
