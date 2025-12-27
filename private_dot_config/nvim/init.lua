--============================================================================
--======== Base Vim Options===================================================
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
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

-- Plugin settings that need to be loaded early. --
vim.g.indentLine_char_list = {'│', '┇', '┊', '┃', '┆', '┋'}
vim.g.vim_json_conceal = 0
--vim.g.indentLine_setConceal = 0

vim.g.Hexokinase_highlighters = { 'backgroundfull' }
vim.g.Hexokinase_alpha_bg = '#000000'

------------------------------------------------------------


o.isfname = "@,48-57,/,.,-,_,+,,,#,$,%,~"

Luna = {}

--============================================================================
--======== Plugin Configuration ==============================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
	    vim.fn.getchar()
	    os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
    	-- Various nvim things seem to need this
		{'nvim-lua/plenary.nvim'},

		-- Fuzzy-finder
		{'nvim-telescope/telescope.nvim'},

		-- Syntax highlighting/parsing
		{'nvim-treesitter/nvim-treesitter', branch = "master", lazy = false, build = ':TSUpdate'},
		{'nvim-treesitter/playground'},


		-- Navigate undo history
		{'mbbill/undotree'},

		-- Git interface
		{'tpope/vim-fugitive'},

		{'neovim/nvim-lspconfig', tag='v1.8.0', pin=true},
		{'hrsh7th/cmp-nvim-lsp'},
		{'hrsh7th/nvim-cmp'},

		{'mason-org/mason.nvim', opts = {}},
		{'mason-org/mason-lspconfig.nvim', opts = {}},

		-- Syntax for fish scripts
		{'khaveesh/vim-fish-syntax'},
		{'ryanoasis/vim-devicons'},

		-- Colorize color codes
		{'rrethy/vim-hexokinase', build = 'make hexokinase' },

		-- Nice which-key menu
		{'folke/which-key.nvim'},

		-- Multiple cursors
		{'mg979/vim-visual-multi'},

		-- Syntax for pegjs
		{'alunny/pegjs-vim'},

		-- Visualize indentation
		{'Yggdroot/indentLine'},

		{'nvimdev/dashboard-nvim'},

		{'fladson/vim-kitty'},
		{'2kabhishek/nerdy.nvim'},

		{'alker0/chezmoi.vim'},
	},

	install = { colorscheme = {"lunacy"} },
	checker = {enabled = true},
})

local lsp_def = require('lspconfig').util.default_config
lsp_def.capabilities = vim.tbl_deep_extend(
	'force',
	lsp_def.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
)

vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		local opts = {buffer = event.buf}
	end,
})



-- " (Optional) Configure lua language server for neovim
--require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
vim.lsp.config('lua_ls', {
	Lua = {
		hint = {
			enable = true,
		}
	}
})
vim.lsp.config('qmlls', {
 	cmd = {"qmlls6", "-E"}
})


--lsp.setup()


-- You need to setup `cmp` after lsp-zero
local cmp = require('cmp')
--local cmp_action = require('lsp-zero').cmp_action()
 
cmp.setup{
	sources = {
	 	{ name = 'nvim_lsp' },
 		{ name = 'luasnip' },
	},
	mapping = {
		['<Tab>'] = cmp.mapping.confirm({select = true}),
		['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item()),
 		['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item()),

		-- Ctrl+Space to trigger completion menu
	    ['<C-Space>'] = cmp.mapping.complete(),

    	-- Navigate between snippet placeholder
--	    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
--	    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
   },
   preselect = cmp.PreselectMode.Item,
   completion = {
 	  completeopt = "menu,menuone"
   }
}
-- 
-- cmp.sources = cmp.config.sources({
-- 	{ name = 'nvim_lsp' },
-- 	{ name = 'luasnip' },
-- }, {
-- 	{ name = 'buffer' },
-- })
-- 

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
-- Previously called from another location, but lazy.nvim loads plugins immediately so this is happening late anyways.
Luna.afterBinds()



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

