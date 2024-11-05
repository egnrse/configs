vim.cmd('source ~/.vimrc')

--vim.opt.guifont = "DejaVuSansM Nerd Font Mono:h10"

if vim.fn.has("gui_running") then
  vim.cmd("set guifont=DejaVuSansM\\ Nerd\\ Font\\ Mono:h32")
--vim.opt.guifont = "JetBrainsMono\\ NFM:h10"
end

language = en_US

require("config.lazy")	--plugins
vim.opt.termguicolors = true

require("maps")			--keymappings
