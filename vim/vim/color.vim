" Gruvbox tuned for Ghostty + tmux true color.
set background=dark
set t_Co=256

if has('termguicolors')
  set termguicolors
endif

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italic = 0
let g:gruvbox_bold = 1
let g:gruvbox_improved_strings = 1
let g:gruvbox_improved_warnings = 1
let g:gruvbox_termcolors = 256

try
  colorscheme gruvbox
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
endtry
