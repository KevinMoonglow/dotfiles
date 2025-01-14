function fish_greeting
    type -q pokemon-colorscripts; and pokemon-colorscripts -r
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

    # Based on https://github.com/badania/scriptz/blob/master/utility/linux-framebuffer-colors.sh
    # And customized to personal color choices
    if test $TERM = "linux"
        echo -en "\e]P0000000" #black
        echo -en "\e]P8767690" #darkgrey
        echo -en "\e]P1e44672" #darkred
        echo -en "\e]P9f38ba8" #red
        echo -en "\e]P26bc663" #darkgreen
        echo -en "\e]PAa6e3a1" #green
        echo -en "\e]P3ffdf6e" #brown
        echo -en "\e]PBf9e2af" #yellow
        echo -en "\e]P44588f4" #darkblue
        echo -en "\e]PC89b4fa" #blue
        echo -en "\e]P5f685dd" #darkmagenta
        echo -en "\e]PDf5c2e7" #magenta
        echo -en "\e]P63bb4c0" #darkcyan
        echo -en "\e]PE94dbe2" #cyan
        echo -en "\e]P7cdd6f4" #lightgrey
        echo -en "\e]PFebeef6" #white
        setterm -background black -store
        setterm -foreground white -store
        clear #for background artifacting
    end
end
fish_add_path --path ~/bin
fish_add_path --path ~/.config/bin
fish_add_path --path ~/.emacs.d/bin
fish_add_path --path ~/.local/bin
