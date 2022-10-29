" Vim color file
" Maintainer: Ted.Que - Que's C++ Studio
" Last Change:	2022 Oct 18

" Set 'background' back to the default.  The value can't always be estimated
" and is then guessed.
set bg&

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "qpp"

hi Visual term=reverse cterm=reverse ctermbg=NONE guibg=grey80
hi VisualNOS term=underline,bold cterm=underline,bold gui=underline,bold
hi Constant	term=underline ctermfg=3	guifg=Magenta
hi String ctermfg=107
hi Statement ctermfg=Brown ctermbg=NONE cterm=NONE
hi Comment ctermfg=DarkBlue ctermbg=NONE cterm=NONE
