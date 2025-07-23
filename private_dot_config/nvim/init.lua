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
o.shell = "/bin/bash"
vim.env.SHELL = "/bin/bash"

vim.cmd.aunmenu "PopUp.How-to\\ disable\\ mouse"
vim.cmd.aunmenu "PopUp.-1-"


-- Display title in gui
o.title = true
o.titlestring = " %t (%f)"

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
o.timeout = true
o.timeoutlen = 300



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
Plug 'tamago324/nlsp-settings.nvim'
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

Plug 'nvimdev/dashboard-nvim'

Plug 'fladson/vim-kitty'
Plug '2kabhishek/nerdy.nvim'

Plug 'alker0/chezmoi.vim'

vim.call("plug#end")


Luna = {}
local lsp = require('lsp-zero').preset("recommended")

lsp.ensure_installed{
--	'tsserver',
	'rust_analyzer',
}

local nlspsettings = require("nlspsettings")

nlspsettings.setup({
  config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
  local_settings_dir = ".nlsp-settings",
  local_settings_root_markers_fallback = { '.git' },
  append_default_schemas = true,
  loader = 'json'
})




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
require('lspconfig').qmlls.setup {
	cmd = {"qmlls6", "-E"}
}


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
	hi(0, "StatusLineNC", {fg="#01579b", bg="white", reverse=true,

							ctermfg=241, ctermbg="white"})

	hi(0, "User1", {fg="#dd65dd", bg="#29315a", ctermfg=170, ctermbg=17})
	hi(0, "User2", {fg="white",   bg="#29315a", ctermfg="white", ctermbg=17})
	hi(0, "User3", {fg="#dd65dd", bg="#aa35aa", ctermfg=170, ctermbg=127})
	hi(0, "User4", {fg="white",   bg="#aa35aa", ctermfg="white", ctermbg=127})
	hi(0, "User5", {fg="#aa35aa", bg="#29315a", ctermfg=127, ctermbg=17})

	hi(0, "WhichKey", {link="String"})
	hi(0, "WhichKeySeperator", {link="Comment"})
	hi(0, "WhichKeyGroup", {link="Keyword"})
	hi(0, "WhichKeyDesc", {link="Function"})
	hi(0, "WhichKeyNormal", {link="User1"})
	hi(0, "WhichKeyTitle", {link="User2"})
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

vim.api.nvim_create_autocmd({"FileType"}, {
	pattern = "dashboard",
	callback = function()
		vim.cmd 'IndentLinesDisable'
		vim.cmd.redraw()
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
--vim.g.indentLine_setConceal = 0

vim.g.Hexokinase_highlighters = { 'backgroundfull' }
vim.g.Hexokinase_alpha_bg = '#000000'


--============================================================================
--======== Keybindings =======================================================
local wk = require("which-key")
wk.setup{
	win = {
		border = "single",
		wo = {
			winblend = 0,
		}
	},
}


function tbind(x) return function() return vim.cmd('silent! tabn ' .. x) end end

--[[
LeaderMap = {name = "+leader"}

LeaderMap.b = {name = "+buffer"}
LeaderMap.p = {name = "+project"}
LeaderMap.g = {name = "+git"}
LeaderMap.x = {name = "+misc"}
LeaderMap.w = {name = "+window"}

local TabMap = {name = "+tab"}
LeaderMap["<tab>"] = TabMap



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

wk.register(LeaderMap, {prefix = "<leader>"})
--]]

wk.add({
    { "<leader>", group = "leader" },
    { "<leader>-", vim.cmd.Ex, desc = "Manage Files" },
    { "<leader><tab>", group = "tab" },
    { "<leader><tab>0", tbind "0", desc = "Last Tab" },
    { "<leader><tab>1", tbind "1", desc = "Tab 1" },
    { "<leader><tab>2", tbind "2", desc = "Tab 2" },
    { "<leader><tab>3", tbind "3", desc = "Tab 3" },
    { "<leader><tab>4", tbind "4", desc = "Tab 4" },
    { "<leader><tab>5", tbind "5", desc = "Tab 5" },
    { "<leader><tab>6", tbind "6", desc = "Tab 6" },
    { "<leader><tab>7", tbind "7", desc = "Tab 7" },
    { "<leader><tab>8", tbind "8", desc = "Tab 8" },
    { "<leader><tab>9", tbind "9", desc = "Tab 9" },
    { "<leader><tab><C-Tab>", "gT", desc = "Prev Tab" },
    { "<leader><tab><Tab>", "gt", desc = "Next Tab" },
    { "<leader><tab>N", vim.cmd.tabnew, desc = "New Tab" },
    { "<leader><tab>[", "gT", desc = "Prev Tab" },
    { "<leader><tab>]", "gt", desc = "Next Tab" },
    { "<leader><tab>d", vim.cmd.tabclose, desc = "Close Tab" },
    { "<leader>[", vim.cmd.bprev, desc = "Prev" },
    { "<leader>]", vim.cmd.bnext, desc = "Next" },
    { "<leader>b", group = "buffer" },
    { "<leader>bN", vim.cmd.enew, desc = "New Buffer" },
    { "<leader>b[", vim.cmd.bprev, desc = "Prev" },
    { "<leader>b]", vim.cmd.bnext, desc = "Next" },
    { "<leader>bd", vim.cmd.bdelete, desc = "Delete Buffer" },
    { "<leader>bn", vim.cmd.bnext, desc = "Next" },
    { "<leader>bp", vim.cmd.bprev, desc = "Prev" },
    { "<leader>g", group = "git" },
    { "<leader>gg", vim.cmd.Git, desc = "Git Status" },
    { "<leader>h", "<C-w>h", desc = "Window ←" },
    { "<leader>j", "<C-w>j", desc = "Window ↓" },
    { "<leader>k", "<C-w>k", desc = "Window ↑" },
    { "<leader>l", "<C-w>l", desc = "Window →" },
    { "<leader>p", group = "project" },
    { "<leader>u", vim.cmd.UndotreeToggle, desc = "Undo Tree" },
	{ "<leader>w", proxy="<c-w>", group="window" },
    -- { "<leader>w", group = "window" },
    -- { "<leader>w+", "<C-w>+", desc = "Height +" },
    -- { "<leader>w-", "<C-w>-", desc = "Height -" },
    -- { "<leader>w<", "<C-w><lt>", desc = "Width -" },
    -- { "<leader>w=", "<C-w>=", desc = "Balance" },
    -- { "<leader>w>", "<C-w><gt>", desc = "Width +" },
    -- { "<leader>w_", "<C-w>_", desc = "Height Max" },
    -- { "<leader>wh", "<C-w>h", desc = "Window ←" },
    -- { "<leader>wj", "<C-w>j", desc = "Window ↓" },
    -- { "<leader>wk", "<C-w>k", desc = "Window ↑" },
    -- { "<leader>wl", "<C-w>l", desc = "Window →" },
    -- { "<leader>w|", "<C-w>|", desc = "Width Max" },
    { "<leader>x", group = "misc" },
    { "<leader>x/", vim.cmd.noh, desc = "Cancel Highlight" },
})








-- Shift lines
vim.keymap.set("n", "<A-j>", ":m .+1<CR>", {desc = "Shift Line Down"})
vim.keymap.set("n", "<A-k>", ":m .-2<CR>", {desc = "Shift Line Up"})
vim.keymap.set("i", "<A-j>", "<C-o>:m .+1<CR>", {desc = "Shift Line Down"})
vim.keymap.set("i", "<A-k>", "<C-o>:m .-2<CR>", {desc = "Shift Line Up"})
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv", {desc = "Shift Lines Down"})
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv", {desc = "Shift Lines Up"})

vim.keymap.set("n", "<leader>?", function() vim.cmd.WhichKey("''") end, {desc = "List Keybinds"})

--vim.keymap.set("i", "<D-.>", "", {})

-- Keybindings that need to be registered after plugins load
-- This function is called in [after/plugin/luna.lua]
function Luna.afterBinds()
	local tele = require("telescope.builtin")
	local nerdy = require('telescope').extensions.nerdy

	vim.keymap.set("n", "<leader>.", tele.find_files, {desc = "Find File"})
	vim.keymap.set("n", "<leader>`", tele.marks, {desc = "List Marks"})
	vim.keymap.set("n", "<leader>/", tele.live_grep, {desc = "Grep Files"})
	vim.keymap.set("n", "<leader>bb", tele.buffers, {desc = "Select Buffer"})
	vim.keymap.set("n", "<leader>gf", tele.git_files, {desc = "Find files in repo"})
	vim.keymap.set("n", "<leader>n", nerdy.nerdy, {desc = "Select a nerd font icon."})
	--vim.keymap.set("n", "<leader>p/", function()
	--	tele.grep_string({ search = vim.fn.input("Grep> ") })
	--end)
end




require("dashboard").setup {
	theme = "doom",
	--preview = {
	--	command = "catimg",
	--	file_path = "~/luna-appr-export.png",
	--	file_width = 40,
	--	file_height = 21,
	--},
	config = {
		header = {"mew"},
		center = {
			{
				icon = '  ',
				icon_hl = "Number",
				group = "string",
				desc = "Open File",
				desc_hl = "String",
				key = "o",
				key_hl = "Type",
				key_format = '  [%s]',
				action = function() require("telescope.builtin").find_files() end,
			},
		},
		footer = {},
	},
}
