-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.keys.normal_mode["<C-s>"] = ":w<CR>"
lvim.keys.insert_mode["<C-s>"] = "<Esc>:w<CR>"
lvim.keys.normal_mode["<C-q>"] = ":q<CR>"

lvim.keys.normal_mode["<A-Down>"] = ":silent! m .+1<CR>=="
lvim.keys.normal_mode["<A-Up>"] = ":silent! m .-2<CR>=="
lvim.keys.visual_mode["<A-Down>"] = ":silent! m '>+1<CR>gv=gv"
lvim.keys.visual_mode["<A-Up>"] = ":silent! m '<-2<CR>gv=gvi"

lvim.transparent_window = true
vim.opt.cursorline = true
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", {
      bg = "NONE",
    })

    vim.api.nvim_set_hl(0, "NormalNC", {
      bg = "NONE",
    })

    vim.api.nvim_set_hl(0, "CursorLine", {
      bg = "#20262B",
    })
  end,
})

local notify = vim.notify

vim.notify = function(msg, level, opts)
  if level == vim.log.levels.WARN then
    return
  end

  notify(msg, level, opts)
end

lvim.builtin.treesitter.indent.enable = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.bo.indentexpr = ""
  end,
})

lvim.keys.normal_mode["<C-h>"] = "dd"
lvim.keys.insert_mode["<C-h>"] = "<Esc>ddi"
lvim.keys.visual_mode["<C-h>"] = "d"

-- Select line up/down
lvim.keys.normal_mode["<C-S-Down>"] = "Vj"
lvim.keys.normal_mode["<C-S-Up>"] = "Vk"
lvim.keys.visual_mode["<C-S-Down>"] = "j"
lvim.keys.visual_mode["<C-S-Up>"] = "k"

-- Move selected block down
lvim.keys.visual_mode["<A-Down>"] = ":m '>+1<CR>gv=gv"

-- Move selected block up
lvim.keys.visual_mode["<A-Up>"] = ":m '<-2<CR>gv=gv"

lvim.keys.normal_mode["<Esc>"] = ":nohlsearch<CR>"

vim.opt.hlsearch = true
vim.opt.incsearch = true

lvim.builtin.indentlines.active = false

lvim.keys.normal_mode["<Home>"] = "^"
lvim.keys.insert_mode["<Home>"] = "<C-O>^"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
