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
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,
  config = function()
    require("rose-pine").setup({
      variant = "main",
      dark_variant = "main",
      styles = {
        bold = true,
        italic = false,
        transparency = false,
      },
      palette = {
        main = {
          base = "#080808",
          surface = "#222129",
          overlay = "#292733",
          muted = "#72707d",
          subtle = "#93919f",
          text = "#e1e0ea",
          love = "#bb8292",
          gold = "#dec6a4",
          rose = "#d9c3c2",
          pine = "#858b8b",
          foam = "#d1d8d8",
          iris = "#cbc2ce",
          leaf = "#a4b1ae",
          highlight_low = "#24242b",
          highlight_med = "#44424c",
          highlight_high = "#565560",
        },
      },
    })

    vim.cmd.colorscheme("rose-pine")
  end,
}
--]]

-- Rose-pine theme colori accesi
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
        bold = true,
        italic = false,
        transparency = false,
      },
      palette = {
        main = {
          base = "#080808",
          surface = "#0f0f12",
          overlay = "#16161c",
          love = "#bb8292",
          gold = "#dec6a4",
          pine = "#7b8888",
          foam = "#c6d8d8",
          iris = "#cfbbd6",
        },
      },
    })

    vim.cmd.colorscheme("rose-pine")
  end,
}
