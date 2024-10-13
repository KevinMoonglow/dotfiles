function pfind --wraps='yay --color -Ss'
    yay --color=always -Ss $argv | less -R +G
end
