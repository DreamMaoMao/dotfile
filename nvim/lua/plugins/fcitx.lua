return {
	"Kicamon/im-switch.nvim",
	config = function()
	  require("im-switch").setup({
      input_toggle = 1, -- 设置为0则默认不自动切换，在insert模式下手动切换为中文后启动自动切换
      text = { -- 写文档
        enable = true,
        files = {
          '*.md',
          '*.txt',
        },
      },
      code = { -- 代码注释
        enable = true,
        files = { '*' },
      },
      en = 'fcitx5-remote -c',
      zh = 'fcitx5-remote -o',
      check = 'fcitx5-remote',

    })
	end,
}

