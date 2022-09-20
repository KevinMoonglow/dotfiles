# Dotfiles
These are just my specific highly opinionated personal configs. This is still a
work in progress while I move everything over to a dotfiles repo.

Borrowing ideas from others, I have this set up to exist in its own `.dotfiles`
directory, and symlinks to configs are created with `stow .`, using [GNU
Stow](https://www.gnu.org/software/stow/).

## Nerd Fonts
Some of the configs here will assume [Nerd Fonts
Symbols](https://github.com/ryanoasis/nerd-fonts) are available. I currently
have these configured through the Terminus font, which is my main text editor
and terminal font.

## Vim
The `.vim` directory currently services both Vim and NeoVim, and the NeoVim
config is currently set up to access it. As a result, the Vim config is made to
be mostly compatible with both editors.

Vim currently uses [vim-plug](https://github.com/junegunn/vim-plug) for plugin
management (installed at `.vim/autoload/plug.vim` . Which means `:PlugInstall`
will need to be run before any of the plugins will work.

LSP support is handled through [coc.vim](https://github.com/neoclide/coc.nvim).
There's a helper function to quickly install all the plugins I'm currently
using which you can run with:

```vim
:call Luna__installCOCPlugins()
```

Alternatively, you could just run the commands in that function by hand and
pick and choose the ones you want installed.

Vim uses `<space>` as the leader key. This brings up `vim-which-key` for a nice
onscreen display of keys that can be pressed. I'm still migrating keybinds
over, so this is very incomplete at the moment.
