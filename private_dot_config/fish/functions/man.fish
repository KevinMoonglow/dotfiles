function man --description 'Recolored man pages' --wraps='man'
 set -x LESS_TERMCAP_mb (tput bold; tput setaf 2) # green
 
 # Bold (headings)
 set -x LESS_TERMCAP_md (string unescape "\e[38;2;255;180;255m") # rgb(255, 180, 255)
 set -x LESS_TERMCAP_me (tput sgr0)

 # Status bar
 set -x LESS_TERMCAP_so (tput bold; tput setaf 15; string unescape "\e[48;2;41;49;90m") # white on rgb(41, 49, 90)
 set -x LESS_TERMCAP_se (tput rmso; tput sgr0)

 # Keywords (underline)
 set -x LESS_TERMCAP_us (tput bold; tput setaf 99)

 set -x LESS_TERMCAP_ue (tput rmul; tput sgr0)
 set -x LESS_TERMCAP_mr (tput rev)
 set -x LESS_TERMCAP_mh (tput dim)
 set -x LESS_TERMCAP_ZN (tput ssubm)
 set -x LESS_TERMCAP_ZV (tput rsubm)
 set -x LESS_TERMCAP_ZO (tput ssupm)
 set -x LESS_TERMCAP_ZW (tput rsupm)
 set -x GROFF_NO_SGR 1
 command man $argv
end
