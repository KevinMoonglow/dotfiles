" Lunacy Color Scheme
" Maintainer: Luna
" Last Change:	
" 
" 

hi clear
if exists("syntax_on")
  syntax reset
endif

set background=dark
let g:colors_name = "lunacy"

highlight Normal       guifg=Grey75       guibg=black
highlight Search           guifg=yellow       guibg=blue
highlight Visual                              guibg=darkslateblue
highlight Cursor           guifg=Black        guibg=#00FF00     gui=bold
highlight CursorColumn                        guibg=Gray15
highlight CursorLine                          guibg=Gray15
highlight Special          guifg=Orange
highlight Comment          guifg=#80a0ff
highlight VertSplit        guifg=navyblue     guibg=slategray   gui=reverse
highlight StatusLine       guifg=navyblue     guibg=white       gui=reverse
highlight StatusLineNC     guifg=Gray40       guibg=white       gui=reverse
highlight StatusLineTerm   guifg=darkgreen    guibg=white       gui=reverse
highlight StatusLineTermNC guifg=gray5        guibg=white       gui=reverse
highlight Statement        guifg=White                          gui=NONE
highlight Type             guifg=LightGreen                     gui=none
highlight Identifier       guifg=Cyan
highlight Constant         guifg=Yellow
highlight Number           guifg=#00FF00
highlight PreProc          guifg=#00FF00
highlight Operator         guifg=LightGreen
highlight Error            guifg=Yellow       guibg=DarkRed
highlight Folded           guifg=White        guibg=DarkBlue
highlight Pmenu            guifg=White        guibg=Black
highlight PmenuSel         guifg=White        guibg=Blue
highlight MatchParen       guifg=White        guibg=Blue
highlight NonText          guifg=#8888FF                        gui=BOLD
highlight SpecialKey       guifg=Cyan
highlight Conceal          guifg=Cyan         guibg=NONE
highlight LineNr           guifg=#999999      guibg=#000044
highlight SignColumn       guifg=#999999      guibg=#000044
highlight TabLineFill      guifg=white        guibg=navy        gui=none
highlight TabLine          guifg=white        guibg=navy        gui=none
highlight TabLineSel       guifg=yellow       guibg=blue        gui=none
highlight Title            guifg=#00FF00                        gui=Underline   guisp=#00FF00
highlight Underlined       guifg=fg                             gui=Underline   guisp=fg


" Console
highlight Normal           ctermfg=LightGrey  ctermbg=black
highlight Search           ctermfg=yellow     ctermbg=darkblue  cterm=NONE
highlight Visual           ctermbg=61
highlight Cursor           ctermfg=Black      ctermbg=Green     cterm=bold
highlight CursorColumn                        ctermbg=235
highlight CursorLine                          ctermbg=235
highlight Special          ctermfg=214                          cterm=bold
highlight Comment          ctermfg=111
highlight VertSplit        ctermfg=17         ctermbg=103       cterm=reverse
highlight StatusLine       ctermfg=17         ctermbg=White
highlight StatusLineNC     ctermfg=242        ctermbg=White
highlight StatusLineTerm   ctermfg=darkgreen  ctermbg=white     cterm=reverse
highlight StatusLineTermNC ctermfg=233        ctermbg=white     cterm=reverse
highlight Statement        ctermfg=White
highlight Type             ctermfg=LightGreen                   cterm=NONE
highlight Identifier       ctermfg=Cyan
highlight Constant         ctermfg=Yellow
highlight Number           ctermfg=Green
highlight PreProc          ctermfg=Green
highlight Operator         ctermfg=LightGreen
highlight Error            ctermfg=Yellow     ctermbg=DarkRed
highlight Folded           ctermfg=White      ctermbg=DarkBlue
highlight Pmenu            ctermfg=White      ctermbg=Black
highlight PmenuSel         ctermfg=White      ctermbg=Blue
highlight MatchParen       ctermfg=white      ctermbg=Blue
highlight NonText          ctermfg=105	      cterm=bold
highlight SpecialKey       ctermfg=Cyan
highlight Conceal          ctermfg=Cyan                         cterm=NONE
highlight LineNr           ctermfg=246        ctermbg=17
highlight SignColumn       ctermfg=246        ctermbg=17
highlight TabLineFill      ctermfg=17         ctermbg=white     cterm=reverse
highlight TabLine          ctermfg=white      ctermbg=17        cterm=none
highlight TabLineSel       ctermfg=yellow     ctermbg=darkblue  cterm=none
highlight Title            ctermfg=green                        cterm=underline

