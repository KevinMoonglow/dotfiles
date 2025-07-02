" Vim syntax file
" Language: FoxMUD area definition
" Maintainer: Timekeeper
" Last Change: ---

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif


syn sync minlines=200
syn case ignore
"syn include @graphite syntax/graphite.vim


"syn keyword fm_objtype room player fixed item npc monster weapon equip food
"syn match fm_roomid / \+[a-zA-Z_\-][a-zA-Z_\-0-9]*/ contained

syn keyword fm_statement flags desc exit pop set loc effect learn level study
syn keyword fm_statement limb slot blocked sides visible lflags
syn keyword fm_statement descprop nameprop nounprop vis nextgroup=fm_prop_scope
syn keyword fm_special_statement readonly

syn match fm_prop_scope ':[a-zA-Z]\+' contained

syn keyword fm_effect_class physical racial mental spiritual magical
syn keyword fm_statement add def nextgroup=fm_objtype
syn match fm_objtype '\s*[a-zA-Z_][a-zA-Z0-9/_]*' contained
syn match fm_number /-\?\<[0-9]\+\>/
syn match fm_float /-\?\<\([0-9]\+\)\?\.[0-9]\+\>/



syn keyword fm_statement health stamina magic mana
syn keyword fm_statement int mag spr wil str grd agi vit
syn keyword fm_stat_rate growth raise abuse from exp
syn keyword fm_stat_rate_level none terrible poor mediocre fair good great grand

syn region fm_string contains=fm_escape start=/"/ skip=/\\\\\|\\"/ end=/"/
" contains=gph_block
syn region fm_string contains=fm_escape start=/"""\n/ end=/\n"""/
syn match fm_escape contained /\\./
"contains=gph_block
"syn region fm_graph matchgroup=fm_graphcont start=/\[/ end=/\]/ contains=@graphite
syn keyword fm_direction north south east west northeast southeast northwest southwest up down in out
syn keyword fm_flavor to as class at by
syn match fm_flavor /[,=]/
syn match fm_seperator /\s-\s/

syn match fm_comment -#.*$- display
syn match fm_path '/[a-zA-Z0-9/_\-~\.@#?]\+' display
syn match fm_obj '[a-zA-Z0-9/_-]\+@[a-zA-Z0-9/_-]\+' display

syn region fm_embed_python matchgroup=fm_embed_cont start=/py\[\[\[$/ end='^\s*\]\]\]py\s*$' contains=@fm_python transparent

syn include @fm_python syntax/python.vim

"syn region fm_embed_gph start=-G"- skip=-\\\\\|\\"- end=-"- contains=gph_block
syn region fm_embed_gph_block matchgroup=fm_embed_cont start=-G<"- end='">G' contains=gph_block keepend

syn region gph_block contained matchgroup=gph_block_grp start='\[' end=']' contains=gph_block,gph_kwd,gph_pstring,gph_litstring,gph_comment,gph_integer,gph_idnumber
syn keyword gph_kwd if then else default return with roll contained
syn keyword gph_kwd tell otell seteffect effecttime style cname contained
syn region gph_pstring start=-"- skip=-\\"- end=-"- contained contains=gph_block
syn region gph_litstring start=-'- skip=-\\'- end=-'- contained
syn region gph_comment start=-//- end=/$/ contained contains=gph_comment
syn match gph_integer /-\?[0-9]\+/ contained
syn match gph_idnumber /#-\?[0-9]\+/ contained


hi link gph_block_grp Operator
hi link gph_kwd Keyword
hi link gph_pstring String
hi link gph_litstring String
hi link gph_comment Comment
hi link gph_integer Number
hi link gph_idnumber identifier

hi link fm_add Statement
hi link fm_roomid Identifier
hi link fm_statement Statement
hi link fm_string string
hi link fm_escape Special
hi link fm_embed_cont Special
hi link fm_embed_gph_block String
hi link fm_direction Identifier
hi link fm_flavor Operator
hi link fm_comment Comment
hi link fm_path identifier
hi link fm_obj identifier
hi link fm_objtype Special
hi link fm_prop_scope Special
hi link fm_special_statement Type

hi link fm_stat_rate statement
hi link fm_stat_rate_level Identifier
hi link fm_effect_class special
hi link fm_number Number
hi link fm_float Float
hi link fm_seperator Special
