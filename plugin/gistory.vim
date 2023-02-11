if exists("g:loaded_gistory_nvim")
    finish
endif
let g:loaded_gistory_nvim = 1

command! Gistory lua require('gistory.init').open_gistory_default()
command! -nargs=1 GistoryB lua require('gistory.init').open_gistory(<args>)
