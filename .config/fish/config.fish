function fish_greeting
    pokemon-colorscripts -r
end


if status is-interactive
    # Commands to run in interactive sessions can go here

    fzf --fish | source
    thefuck --alias | source
    thefuck --alias heck | source
    zoxide init fish | source
    alias cd __zoxide_z

    oh-my-posh init --config ~/.config/ohmyposh/luna.omp.json fish | source
end
fish_add_path --path ~/bin
fish_add_path --path ~/.config/bin
fish_add_path --path ~/.emacs.d/bin

