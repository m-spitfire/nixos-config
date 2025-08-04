vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.swapfile = false
vim.opt.hlsearch = false
-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.opt.colorcolumn = "80"

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.clipboard = 'unnamedplus'
vim.g.mapleader = ' '

vim.keymap.set("v", "<C-c>", "y:call SendViaOSC52(getreg('\"'))<cr>")

vim.pack.add({
    { src = "https://github.com/echasnovski/mini.pick" },
})

require "mini.pick".setup({
    mappings = {
        move_down = '<C-j>',
        move_up   = '<C-k>',
    }
})
-- require "nvim-treesitter.configs".setup({
--     ensure_installed = { "nix" },
--     highlight = { enable = true }
-- })

vim.keymap.set('n', '<leader>f', ":Pick files<CR>")
vim.keymap.set('n', '<leader><space>', ":Pick buffers<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")
