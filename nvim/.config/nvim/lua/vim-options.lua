vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- Default personale (esempio): 2 spazi
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- Re-detect filetype after saving a new file (e.g. a script with a shebang
-- but no extension). Neovim only runs shebang detection on BufReadPost, so
-- a freshly created buffer never gets a filetype -> no treesitter/LSP.
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    if vim.bo.filetype == "" then
      vim.cmd("filetype detect")
    end
  end,
})

-- Leader key
vim.g.mapleader = " "

-- File operations
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")
vim.keymap.set("n", "<leader>fq", ":q!<CR>")

-- Pane navigation
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")

-- Plugins
vim.keymap.set("n", "<leader>pm", ":Lazy<CR>")

-- File explorer (built-in, replaces oil/neo-tree)
vim.keymap.set("n", "<leader>pv", ":Ex<CR>")

-- Search
vim.keymap.set("n", "<ESC>", "<cmd>nohlsearch<CR>")

-- Disable arrow keys
for _, mode in ipairs({ "n", "i", "v" }) do
  vim.keymap.set(mode, "<Up>", '<ESC>:echoe "Use k"<CR>')
  vim.keymap.set(mode, "<Down>", '<ESC>:echoe "Use j"<CR>')
  vim.keymap.set(mode, "<Right>", '<ESC>:echoe "Use l"<CR>')
  vim.keymap.set(mode, "<Left>", '<ESC>:echoe "Use h"<CR>')
end

-- Insert mode escape
vim.keymap.set("i", "jk", "<ESC>")
vim.o.timeoutlen = 250

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<C-f>", function()
  vim.fn.system("tmux neww tmux-sessionizer")
end, { desc = "tmux sessionizer" })
