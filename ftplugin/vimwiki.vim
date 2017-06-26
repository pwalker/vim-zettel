" get active VimWiki directory
let g:zettel_dir = VimwikiGet('path',g:vimwiki_current_idx)

" fzf returns selected filename and matched line from the file, we need to
" strip that
function! s:get_fzf_filename(line)
  " the filename is separated by : from rest of the line
  let parts =  split(a:line,":")
  " remove the extension
  let filename = parts[0]
  let fileparts = split(filename, '\V.')
  " insert the filename into current buffer
  execute 'normal a' fileparts[0]
endfunction

" make fulltext search in all VimWiki files using FZF
command! -bang -nargs=* ZettelSearch call fzf#vim#ag(<q-args>, 
      \'--skip-vcs-ignores', {
      \'down': '~40%',
      \'sink':function('<sid>get_fzf_filename'),
      \'dir':g:zettel_dir,
      \'options':'--exact'})

function! s:zettel_new()
  let format = strftime("%y%m%d-%H%M")
  " this doesn't work
  execute 'normal :e' format
endfunction

command! ZettelNew execute <sid>zettel_new()

" remap [[ to start fulltext search
inoremap [[ [[<esc>:ZettelSearch<CR>

