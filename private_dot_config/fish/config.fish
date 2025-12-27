function fish_greeting
    type -q pokemon-colorscripts; and pokemon-colorscripts -r
end
function fish_title
    if set -q argv[1]
        echo -- "  "(string sub -l 20 -- $argv[1])
    else
        set -l command (status current-command)
        echo -- "  "(string sub -l 20 -- $command)
    end
end

if status is-interactive
    # Commands to run in interactive sessions can go here

    if type -q fzf
        fzf --fish | source
    end
    if type -q thefuck
        thefuck --alias | source
        thefuck --alias heck | source
    end
    if type -q zoxide
        zoxide init fish | source
        alias cd __zoxide_z
    end

    if type -q oh-my-posh
        oh-my-posh init --config ~/.config/ohmyposh/luna.omp.toml fish | source
    end

    if type -q exa
        set -g __fish_ls_command exa
        set -g __fish_ls_indicators_opt -F --icons=always --hyperlink
    end

    # Based on https://github.com/badania/scriptz/blob/master/utility/linux-framebuffer-colors.sh
    # And customized to personal color choices
    if test $TERM = "linux"
        echo -en "\e]P0000000" #black
        echo -en "\e]P8767690" #darkgrey    -> #767690
        echo -en "\e]P1e44672" #darkred     -> #e44672
        echo -en "\e]P9f38ba8" #red         -> #f38ba8
        echo -en "\e]P26bc663" #darkgreen   -> #6bc663
        echo -en "\e]PAa6e3a1" #green       -> #a6e3a1
        echo -en "\e]P3ffdf6e" #brown       -> #ffdf6e
        echo -en "\e]PBf9e2af" #yellow      -> #f9e2af
        echo -en "\e]P44588f4" #darkblue    -> #4588f4
        echo -en "\e]PC89b4fa" #blue        -> #89b4fa
        echo -en "\e]P5f685dd" #darkmagenta -> #f685dd
        echo -en "\e]PDf5c2e7" #magenta     -> #f5c2e7
        echo -en "\e]P63bb4c0" #darkcyan    -> #3bb4c0
        echo -en "\e]PE94dbe2" #cyan        -> #94dbe2
        echo -en "\e]P7cdd6f4" #lightgrey   -> #cdd6f4
        echo -en "\e]PFebeef6" #white       -> #ebeef6
        setterm -background black -store
        setterm -foreground white -store
        clear #for background artifacting
    end
end
fish_add_path --path ~/bin
fish_add_path --path ~/.config/bin
fish_add_path --path ~/.emacs.d/bin
fish_add_path --path ~/.local/bin

set fish_pager_color_background --background=#29315a
set fish_pager_color_progress --background='#dd65dd' '#ffffff'
