

--============================================================================
--======== Base Vim Options===================================================
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>-", vim.cmd.Ex)

vim.keymap.set("n", "<leader>bn", vim.cmd.bnext)
vim.keymap.set("n", "<leader>bp", vim.cmd.bprev)
vim.keymap.set("n", "<leader>b]", vim.cmd.bnext)
vim.keymap.set("n", "<leader>b[", vim.cmd.bprev)

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
-- Git stuff
vim.keymap.set('n', "<leader>gg", vim.cmd.Git)

vim.keymap.set('n', "<leader>x/", vim.cmd.noh)

-- Shift lines
vim.keymap.set("n", "<A-j>", ":m .+1<CR>")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>")
vim.keymap.set("i", "<A-j>", "<C-o>:m .+1<CR>")
vim.keymap.set("i", "<A-k>", "<C-o>:m .-2<CR>")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv")
-- Basic 
local o = vim.o

-- Personal color scheme
vim.cmd.colors "lunacy"

-- Avoid issues with default shell being fish
o.shell = "/bin/zsh"
vim.env.SHELL = "/bin/zsh"

-- Display title in gui
o.title = true

-- Because 8 is just a bit ridiculous
o.tabstop = 4
o.shiftwidth = 4

-- Better line wrapping
o.linebreak = true


o.showbreak = "<   "
o.listchars = "tab:» "

o.encoding = "utf8"

-- The 'I' flag disables the startup splash.
o.shortmess = o.shortmess .. "I"

-- Setup relative number column with LSP signs.
o.signcolumn = "number"
o.number = true
o.relativenumber = true
o.numberwidth = 5

o.termguicolors = true


o.backupdir = vim.fn.expand("~/.local/state/nvim/backup")

-- nvim-qt font settings at: [../nvim-qt/nvim-qt.conf]


-- Make the which-key menu come up quicker.
o.timeout = 300



--============================================================================
--======== Plugin Configuration ==============================================
local Plug = vim.fn['plug#']

vim.call("plug#begin", vim.fn.stdpath("data") .. "/plugged")

-- Various nvim things seem to need this
Plug 'nvim-lua/plenary.nvim'

-- Fuzzy-finder
Plug 'nvim-telescope/telescope.nvim'

-- Syntax highlighting/parsing
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug 'nvim-treesitter/playground'

-- Navigate undo history
Plug 'mbbill/undotree'

-- Git interface
Plug 'tpope/vim-fugitive'

-- LSP Support
Plug 'neovim/nvim-lspconfig'                               -- Required
Plug('williamboman/mason.nvim', {['do'] = ':MasonUpdate'}) -- Optional
Plug 'williamboman/mason-lspconfig.nvim'                   -- Optional

-- Autocompletion
Plug 'hrsh7th/nvim-cmp'     -- Required
Plug 'hrsh7th/cmp-nvim-lsp' -- Required
Plug 'L3MON4D3/LuaSnip'     -- Required

Plug('VonHeikemen/lsp-zero.nvim', {branch = 'v2.x'})

-- Syntax for fish scripts
Plug 'khaveesh/vim-fish-syntax'
Plug 'ryanoasis/vim-devicons'

-- Colorize color codes
Plug('rrethy/vim-hexokinase', { ['do'] = 'make hexokinase' })

-- Nice which-key menu
Plug 'folke/which-key.nvim'

-- Multiple cursors
Plug 'mg979/vim-visual-multi'

-- Syntax for pegjs
Plug 'alunny/pegjs-vim'

-- Visualize indentation
Plug 'Yggdroot/indentLine'

vim.call("plug#end")


Luna = {}
local lsp = require('lsp-zero').preset("recommended")

lsp.ensure_installed{
	'tsserver',
	'rust_analyzer',
}


lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

-- " (Optional) Configure lua language server for neovim
--require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
require('lspconfig').lua_ls.setup({
	Lua = {
		hint = {
			enable = true,
		}
	}
})
lsp.setup()


-- You need to setup `cmp` after lsp-zero
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup{
  mapping = {
    ['<Tab>'] = cmp.mapping.confirm({select = true}),
	['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item()),
	['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item()),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  },
  preselect = cmp.PreselectMode.Item,
  completion = {
	  completeopt = "menu,menuone"
  }
}

cmp.sources = cmp.config.sources({
	{ name = 'nvim_lsp' },
	{ name = 'luasnip' },
}, {
	{ name = 'buffer' },
})


-- Personal late actions: [after/plugin/luna.lua]

function Luna.userColors()
	local hi = vim.api.nvim_set_hl
	hi(0, "StatusLine", {fg="#dd65dd", bg="white", reverse=true,
							ctermfg=170, ctermbg="white"})
	hi(0, "StatusLineNC", {fg="Gray40", bg="white", reverse=true,

							ctermfg=241, ctermbg="white"})

	hi(0, "User1", {fg="#dd65dd", bg="darkblue", ctermfg=170, ctermbg=17})
	hi(0, "User2", {fg="white",   bg="darkblue", ctermfg="white", ctermbg=17})
	hi(0, "User3", {fg="#dd65dd", bg="#aa35aa", ctermfg=170, ctermbg=127})
	hi(0, "User4", {fg="white",   bg="#aa35aa", ctermfg="white", ctermbg=127})
	hi(0, "User5", {fg="#aa35aa", bg="darkblue", ctermfg=127, ctermbg=17})

	hi(0, "WhichKey", {link="String"})
	hi(0, "WhichKeySeperator", {link="Comment"})
	hi(0, "WhichKeyGroup", {link="Keyword"})
	hi(0, "WhichKeyDesc", {link="Function"})
	hi(0, "WhichKeyFloat", {link="User1"})
	hi(0, "WhichKeyBorder", {link="User1"})

	--hi(0, "WhichKeyFloating", {fg="fg", bg="navy", ctermbg=17})
end

vim.api.nvim_create_augroup("Luna__statuscols", {clear=true})
vim.api.nvim_create_autocmd({"ColorScheme", "VimEnter"}, {
	callback = Luna.userColors,
	group = "Luna__statuscols",
})
vim.api.nvim_create_augroup("Luna__setup", {clear=true})


-- Restore cursor position on file load.
vim.api.nvim_create_autocmd({"BufReadPost"}, {
	callback = function()
		local line = vim.fn.line
		local lp = line([['"]])
		if lp > 0 and lp < line("$") then
			vim.cmd.normal 'g`"'
		end
	end,
	group = "Luna__setup",
})


vim.o.statusline = [[%<%f %h%m%r%1*%*%2*]] ..
               [[%=%5*%4*%4P %3*%*%14.(%l,%c%V%)]]



require'nvim-treesitter.configs'.setup{
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript" },
	highlight = {enable=true},
}

vim.g.indentLine_char_list = {'│', '┇', '┊', '┃', '┆', '┋'}
vim.g.vim_json_conceal = 0

vim.g.Hexokinase_highlighters = { 'backgroundfull' }
vim.g.Hexokinase_alpha_bg = '#000000'


--============================================================================
--======== Keybindings =======================================================
local wk = require("which-key")
wk.setup{
	window = {
		border = "single",
		winblend = 0,
	}
}

LeaderMap = {name = "+leader"}

LeaderMap.b = {name = "+buffer"}
LeaderMap.p = {name = "+project"}
LeaderMap.g = {name = "+git"}
LeaderMap.x = {name = "+misc"}
LeaderMap.w = {name = "+window"}

local TabMap = {name = "+tab"}
LeaderMap["<tab>"] = TabMap

function tbind(x) return function() return vim.cmd('silent! tabn ' .. x) end end


TabMap['<Tab>'] = {"gt", "Next Tab"}
TabMap['<C-Tab>'] = {"gT", "Prev Tab"}
TabMap['1'] = {tbind '1', "Tab 1"}
TabMap['2'] = {tbind '2', "Tab 2"}
TabMap['3'] = {tbind '3', "Tab 3"}
TabMap['4'] = {tbind '4', "Tab 4"}
TabMap['5'] = {tbind '5', "Tab 5"}
TabMap['6'] = {tbind '6', "Tab 6"}
TabMap['7'] = {tbind '7', "Tab 7"}
TabMap['8'] = {tbind '8', "Tab 8"}
TabMap['9'] = {tbind '9', "Tab 9"}
TabMap[']'] = {"gt", "Next Tab"}
TabMap['['] = {"gT", "Prev Tab"}
TabMap['0'] = {vim.cmd.tablast, "Last Tab"}
TabMap.N = {vim.cmd.tabnew, "New Tab"}
TabMap.d = {vim.cmd.tabclose, "Close Tab"}


LeaderMap.w["+"] = {"<C-w>+", "Height +"}
LeaderMap.w["-"] = {"<C-w>-", "Height -"}
LeaderMap.w[">"] = {"<C-w><gt>", "Width +"}
LeaderMap.w["<"] = {"<C-w><lt>", "Width -"}
LeaderMap.w["="] = {"<C-w>=", "Balance"}
LeaderMap.w["_"] = {"<C-w>_", "Height Max"}
LeaderMap.w["|"] = {"<C-w>|", "Width Max"}
LeaderMap.w.h = {"<C-w>h", "Window ←"}
LeaderMap.w.j = {"<C-w>j", "Window ↓"}
LeaderMap.w.k = {"<C-w>k", "Window ↑"}
LeaderMap.w.l = {"<C-w>l", "Window →"}
LeaderMap.h = {"<C-w>h", "Window ←"}
LeaderMap.j = {"<C-w>j", "Window ↓"}
LeaderMap.k = {"<C-w>k", "Window ↑"}
LeaderMap.l = {"<C-w>l", "Window →"}


LeaderMap['-'] = {vim.cmd.Ex, "Manage Files"}
LeaderMap.b.n = {vim.cmd.bnext, "Next"}
LeaderMap.b.p = {vim.cmd.bprev, "Prev"}
LeaderMap.b["]"] = {vim.cmd.bnext, "Next"}
LeaderMap.b["["] = {vim.cmd.bprev, "Prev"}
LeaderMap.b.N = {vim.cmd.enew, "New Buffer"}
LeaderMap.b.d = {vim.cmd.bdelete, "Delete Buffer"}
LeaderMap["]"] = {vim.cmd.bnext, "Next"}
LeaderMap["["] = {vim.cmd.bprev, "Prev"}




LeaderMap.x['/'] = {vim.cmd.noh, "Cancel Highlight"}

LeaderMap.u = {vim.cmd.UndotreeToggle, "Undo Tree"}

LeaderMap.g.g = {vim.cmd.Git, "Git Status"}


-- Shift lines
vim.keymap.set("n", "<A-j>", ":m .+1<CR>", {desc = "Shift Line Down"})
vim.keymap.set("n", "<A-k>", ":m .-2<CR>", {desc = "Shift Line Up"})
vim.keymap.set("i", "<A-j>", "<C-o>:m .+1<CR>", {desc = "Shift Line Down"})
vim.keymap.set("i", "<A-k>", "<C-o>:m .-2<CR>", {desc = "Shift Line Up"})
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv", {desc = "Shift Lines Down"})
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv", {desc = "Shift Lines Up"})


vim.keymap.set("n", "<leader>?", function() vim.cmd.WhichKey("''") end, {desc = "List Keybinds"})

-- Keybindings that need to be registered after plugins load
-- This function is called in [after/plugin/luna.lua]
function Luna.afterBinds()
	local tele = require("telescope.builtin")

	vim.keymap.set("n", "<leader>.", tele.find_files, {desc = "Find File"})
	vim.keymap.set("n", "<leader>`", tele.marks, {desc = "List Marks"})
	vim.keymap.set("n", "<leader>/", tele.live_grep, {desc = "Grep Files"})
	vim.keymap.set("n", "<leader>bb", tele.buffers, {desc = "Select Buffer"})
	vim.keymap.set("n", "<leader>gf", tele.git_files, {desc = "Find files in repo"})
	--vim.keymap.set("n", "<leader>p/", function()
	--	tele.grep_string({ search = vim.fn.input("Grep> ") })
	--end)
end


wk.register(LeaderMap, {prefix = "<leader>"})







