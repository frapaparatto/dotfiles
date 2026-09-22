--[[
return {
  {
    "tjdevries/colorbuddy.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("gruvbuddy")
    end,
  },
}
--]]

--[[
return {
  "p0209p/naysayer.vim",
  priority = 1000,
  lazy = false,
  config = function()
    vim.cmd.colorscheme("naysayer")
  end,
}
--]]

-- Rose-pine theme
return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,
  config = function()
    require("rose-pine").setup({
      variant = "main",
      dark_variant = "main",
      styles = {
        bold = false,
        italic = false,
        transparency = false,
      },
      palette = {
        main = {
          -- overlay = "#16161c",
          -- love = "#bb8292",
          -- gold = "#dec6a4",
          iris = "#cbc2ce",
        },
      },
    })

    vim.cmd.colorscheme("rose-pine")
  end,
}
