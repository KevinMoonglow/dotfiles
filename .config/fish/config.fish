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
end
fish_add_path --path ~/bin
fish_add_path --path ~/.config/bin
fish_add_path --path ~/.emacs.d/bin
fish_add_path --path ~/.local/bin
