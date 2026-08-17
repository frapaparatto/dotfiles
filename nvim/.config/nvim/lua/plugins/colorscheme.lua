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
  "vague-theme/vague.nvim",
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other plugins
  config = function()
    -- NOTE: you do not need to call setup if you don't want to.
    require("vague").setup({
      -- optional configuration here
    })
    vim.cmd("colorscheme vague")
  end,
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
