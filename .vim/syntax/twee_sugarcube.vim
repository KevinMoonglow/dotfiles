" Vim syntax file
" Language: Twee (Sugarcube)
" Maintainer: Luna
" Last Change: Thu Jun 23 16:29:18 PDT 2022

if !exists("main_syntax")
	if exists("b:current_syntax")
		finish
	endif
	let main_syntax = 'twee_snowman'
endif

runtime! syntax/html.vim
unlet b:current_syntax

syntax include @javascript syntax/javascript.vim
syntax include @json syntax/json.vim
syntax sync minlines=100

syn region twPassageHeading start='^::' end='$' matchgroup=twPassageHeadingSymbol contains=twTagsList keepend
syn region twPassageStoryData start='^::\sStoryData' end='\n' matchgroup=twPassageHeadingSymbol contains=twTagsList nextgroup=twStoryDataBlock keepend
syn match twTagsList /\[[^]]*\]/ contained
syn region twStoryDataBlock start='' end=/^::/me=e-2 contained contains=@json keepend
syn region twMacroTag matchgroup=twMacroBoundary start='<<[^/]'rs=e-1 end='>>' contains=twMacroNames,twStoryVar,twTempVar,@javascript keepend
syn region twMacroTag matchgroup=twMacroBoundary start='<<[/=]' end='>>' contains=twMacroNames,twStoryVar,twTempVar,@javascript keepend 
syn region twScriptTags matchgroup=twScriptBoundary start='<<script>>' end='<</script>>' contains=@javascript keepend
syn keyword twMacroNames contained set run link capture unset include nobr print silently type button checkbox cycle option optionsfrom linkappend linkprepend linkreplace listbox numberbox radiobutton textarea textbox actions back choice addclass append copy prepend remove removeclass replace toggleclass audio cacheaudio createaudioegroup createplaylist masteraudio playlist removeaudiogroup removeplaylist waitforaudio done goto repeat stop timed widget
syn match twStoryVar /\$[a-zA-Z_][a-zA-Z0-9_.]*\(\[[0-9a-zA-Z_$'"]*\]\)\?/
syn match twTempVar /_[a-zA-Z_][a-zA-Z0-9_.]*/
syn region twPassageLink start=/\[\[/ end=/]]/
syn region twImageLink start=/\[img\[/ end=/]]/
syn region twHeading start=/^!/ end=/$/ contains=TOP,twHeading
syn region twEmph matchgroup=twEmphEnds start=-//- end=-//- contains=TOP,twEmph
syn region twStrong matchgroup=twStrongEnds start=-''- end=-''- contains=TOP,twStrong
syn region twUnderline matchgroup=twUnderlineEnds start=-__- end=-__- contains=TOP,twUnderline
syn region twStrike matchgroup=twStrikeEnds start=-==- end=-==- contains=TOP,twStrike
syn match twTemplate /?[a-zA-Z][a-zA-Z0-9_-]*/


hi link twPassageHeading Identifier
hi link twPassageHeadingSymbol Operator
hi link twPassageList Special
hi link twPassageStoryData Identifier
hi link twTagsList Special
hi link twMacroNames Keyword
hi link twStoryVar Identifier
hi link twTempVar Identifier
hi link twPassageLink Identifier
hi link twImageLink String
hi link twMacroBoundary Operator
hi link twScriptBoundary Special
hi link twHeading Title
hi link twTemplate Special
hi twEmph gui=italic term=italic
hi twStrong gui=bold term=bold
hi twUnderline gui=underline term=underline
hi twStrike gui=strikethrough term=strikethrough
