" Vim syntax file
" Language: Muck MPI
" Maintainer: Timekeeper
" Last Change: Mon Sep  8 06:08:01 PDT 2008
" Extremely simple and lazy, but still does the job of making it more
" readable.

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syntax sync minlines=100

syn region mpiBlock matchgroup=mpiBraces start='{' skip='\\{' end='}' contains=mpiInside
"syn region mpiVar start='{&' skip='\}' end='}' keepend
syn match mpiInside contained '[a-zA-Z?]\+' nextgroup=mpiColon
syn match mpiColon contained ':\n\?' nextgroup=mpiParam
"syn match mpiParam contained /\(\\.\|[^,}]\)*/ nextgroup=mpiComma contains=mpiBlock,mpiVar
syn region mpiParam contained start=/\(\\.\|[^,}]\)\?/ skip='\\,\|\\}' end='\(,\|}\)\@=' nextgroup=mpiComma contains=mpiBlock,mpiVar,mpiParmEscape,mpiMacroParm
syn match mpiComma contained ',\n\?' nextgroup=mpiParam
syn match mpiVar /{&[a-zA-Z]\+}/
syn match mpiMacroParm /{:[0-9]}/
syn match mpiEscape /{{/
syn match mpiParmEscape /\\./


hi link mpiBraces PreProc
hi link mpiInside Normal
hi link mpiColon operator
hi link mpiComma operator
hi link mpiParam String
hi link mpiVar Identifier
hi link mpiMacroParm Identifier
hi link mpiContainedVar Identifier
hi link mpiEscape Special
hi link mpiParmEscape Special
let b:current_syntax = "mpi"
