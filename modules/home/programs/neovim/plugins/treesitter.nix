{pkgs, ...}: {
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
      type = "lua";
      config =
        # lua
        ''
          require("nvim-treesitter.configs").setup({
              autopairs = {
                  enable = true,
              },
              highlight = {
                  enable = true,
              },
              indent = {
                  enable = true,
              },
          })
        '';
    }
  ];
}
