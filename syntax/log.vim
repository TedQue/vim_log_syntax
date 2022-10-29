" Vim syntax file
" Language:	log
" Maintainer:	Ted.Que - Que's C++ Studio
" Last Change:	2022 Oct 24

let s:cpo_save = &cpo
set cpo&vim

" A bunch of useful LOG keywords
syn keyword	logLabel		FATAL ERROR WARNING INFO DEBUG TRACE 
syn keyword Error			FATAL ERROR
syn keyword Todo			WARNING

" log level groups
syn match logFatal		contained " - FATAL - "
syn match logError		contained " - ERROR - "
syn match logWarning	contained " - WARNING - "
syn match logInfo		contained " - INFO - "
syn match logDebug		contained " - DEBUG - "
syn match logTrace		contained " - TRACE - "

" string charracter
syn region	logString		start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match	logCharacter	"L\='[^\\]'"

" integer number, or floating point number without a dot and with "f".
syn match	logNumbers	display transparent "\<\d\|\.\d" contains=logNumber,logFloat,logOctal
syn match	logNumber	display contained "\d\+\%(u\=l\{0,2}\|ll\=u\)\>"
syn match	logNumber	display contained "0x\x\+\%(u\=l\{0,2}\|ll\=u\)\>"
syn match	logFloat	display contained "\d\+\.\d*\%(e[-+]\=\d\+\)\=[fl]\="
syn match	logFloat	display contained "\.\d\+\%(e[-+]\=\d\+\)\=[fl]\=\>"
syn match	logFloat	display contained "\d\+e[-+]\=\d\+[fl]\=\>"

" date time
syn match	logDate	"\<\d\{2,4}[/-]\d\{2}[/-]\d\{2,4}\>"
syn match	logDate	"\<[12]\d\{3}[01]\d[0123]\d\>"
syn match	logTime	"\<\d\{2}:\d\{2}:\d\{2}\>"

" comment, start with #
syn region	logComment	start="^\s*#" end="$" keepend

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link logLabel		Label
hi def link logString		String
hi def link logCharacter	Character
hi def link logNumbers		Number
hi def link logNumber		Number
hi def link logFloat		Number
hi def link logDate			PreProc
hi def link logTime			PreProc
hi def link logComment		Comment

let b:current_syntax = "log"

let &cpo = s:cpo_save
unlet s:cpo_save
