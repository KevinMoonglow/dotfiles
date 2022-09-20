" NeoVim specific configs

" Add the normal Vim runtime paths
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Execute the default vimrc
source ~/.vim/vimrc

" neogit only works in NeoVim, so here's the initialization for it.
lua << ENDL
local neogit = require('neogit')

neogit.setup{
	integrations = { diffview = true }
}
ENDL
