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


highlight Normal           guifg=#ccd1f6      guibg=black
highlight CurSearch		   guifg=#ffc5fc      guibg=#022A80
highlight Search           guifg=#ffe766      guibg=#022A80
highlight Visual                              guibg=#29315a
highlight Cursor           guifg=Black        guibg=#ffc5fc     gui=bold
highlight CursorColumn                        guibg=#505a7f
highlight CursorLine                          guibg=#505a7f
highlight Special          guifg=#ffa333
highlight Comment          guifg=#80aaff
highlight VertSplit        guifg=#022a80      guibg=#505a7f     gui=reverse
highlight StatusLine       guifg=#01579b      guibg=#eeeeff     gui=reverse
highlight StatusLineNC     guifg=#29315a      guibg=#eeeeff     gui=reverse
highlight StatusLineTerm   guifg=#6aaf76      guibg=#eeeeff     gui=reverse
highlight StatusLineTermNC guifg=#3f7448      guibg=#eeeeff     gui=reverse
highlight Statement        guifg=#eeeeff                        gui=NONE
highlight Type             guifg=#80ff96                        gui=NONE
highlight Identifier       guifg=#76d1ff
highlight Function         guifg=#76d1ff
highlight @variable        guifg=#43c0ff
highlight Constant         guifg=#ffaafc
highlight String           guifg=#ffaafc
highlight Number           guifg=#80ff96
highlight PreProc          guifg=#3f7448
highlight Operator         guifg=#6aaf76
highlight Error            guifg=#ffe766      guibg=#990055
highlight Folded           guifg=#eeeeff      guibg=#29315a
highlight Pmenu            guifg=#eeeeff      guibg=#29315a
highlight PmenuSel         guifg=#dd65dd      guibg=#eeeeff
highlight MatchParen       guifg=#eeeeff      guibg=#dd65dd
highlight NonText          guifg=#bb89ff                        gui=BOLD
highlight SpecialKey       guifg=#76d1ff
highlight Conceal          guifg=#76d1ff      guibg=NONE
highlight LineNr           guifg=#ccd1f6      guibg=#00004b
highlight SignColumn       guifg=#ccd1f6      guibg=#00004b
highlight TabLineFill      guifg=#eeeeff      guibg=#29315a     gui=none
highlight TabLine          guifg=#eeeeff      guibg=#01579b     gui=none
highlight TabLineSel       guifg=#eeeeff      guibg=#dd65dd     gui=none
highlight Title            guifg=#ffaafc                        gui=Underline   guisp=#ffaafc
highlight Underlined       guifg=fg                             gui=Underline   guisp=fg
highlight FloatBorder      guifg=#eeeeff      guibg=NONE
highlight Todo             guifg=#ffe766  	  guibg=#29315a     gui=Underline


" Console
highlight Normal           ctermfg=189        ctermbg=black
highlight CurSearch		   ctermfg=219        ctermbg=18
highlight Search           ctermfg=221        ctermbg=18        cterm=NONE
highlight Visual           ctermbg=61
highlight Cursor           ctermfg=Black      ctermbg=219       cterm=bold
highlight CursorColumn                        ctermbg=235
highlight CursorLine                          ctermbg=235
highlight Special          ctermfg=215                          cterm=bold
highlight Comment          ctermfg=111
highlight VertSplit        ctermfg=18         ctermbg=235       cterm=reverse
highlight StatusLine       ctermfg=25         ctermbg=White
highlight StatusLineNC     ctermfg=61         ctermbg=White
highlight StatusLineTerm   ctermfg=71         ctermbg=white     cterm=reverse
highlight StatusLineTermNC ctermfg=65         ctermbg=white     cterm=reverse
highlight Statement        ctermfg=White
highlight Type             ctermfg=84                           cterm=NONE
highlight Identifier       ctermfg=117
highlight Function         ctermfg=117
highlight Constant         ctermfg=219
highlight String           ctermfg=219
highlight Number           ctermfg=71
highlight PreProc          ctermfg=65
highlight Operator         ctermfg=84
highlight Error            ctermfg=221        ctermbg=125
highlight Folded           ctermfg=White      ctermbg=61
highlight Pmenu            ctermfg=White      ctermbg=18
highlight PmenuSel         ctermfg=170        ctermbg=white
highlight MatchParen       ctermfg=white      ctermbg=170
highlight NonText          ctermfg=141	      cterm=bold
highlight SpecialKey       ctermfg=117
highlight Conceal          ctermfg=117                          cterm=NONE
highlight LineNr           ctermfg=white      ctermbg=18
highlight SignColumn       ctermfg=white      ctermbg=18
highlight TabLineFill      ctermfg=18         ctermbg=white     cterm=reverse
highlight TabLine          ctermfg=white      ctermbg=25        cterm=none
highlight TabLineSel       ctermfg=246        ctermbg=170       cterm=none
highlight Title            ctermfg=219                          cterm=underline
highlight Underlined	   ctermfg=fg                           cterm=underline
highlight FloatBorder      ctermfg=white      ctermbg=NONE
highlight Todo			   ctermfg=221        ctermbg=18

