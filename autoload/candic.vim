scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! candic#init() abort " {{{
  return {}
endfunction " }}}

function! s:kname(key) abort " {{{
  return a:key
endfunction " }}}

function! candic#append(dict, key, value) abort " {{{
" @return 1 if key is invalid (empty-string)
  let key = s:kname(a:key)
  if key ==# ''
    return 1
  endif
  let a:dict[key] = a:value
endfunction " }}}

function! s:remove(dict, key) abort " {{{
  unlet a:dict[a:key]
  return 0
endfunction " }}}

function! candic#remove(dict, ...) abort " {{{
" removes elements from {dict}.
" Note: candict#remove(d, '') removes all elements from d
" @return number of removed elements
  let keys = call(function('candic#keys'), [a:dict] + a:000)
  let n = len(keys)
  for k in keys
    " map() returns E685
    call s:remove(a:dict, k)
  endfor
  return n
endfunction " }}}

function! candic#keys(dict, ...) abort " {{{
" keys(dict [, key, [flag]])
" @return candidates which start with a:key
" @return all candicates if a:key=''
  let key = a:0 == 0 ? '' : s:kname(a:1)
  let regexp = get(a:000, 1, 0)
  if key ==# ''
    return keys(a:dict)
  elseif regexp
    let ks = keys(a:dict)
    return filter(ks, 'v:val =~# key')
  else
    let ks = keys(a:dict)
    let key = '^' . key
    return filter(ks, 'v:val =~# key')
  endif
endfunction " }}}

function! candic#values(dict, ...) abort " {{{
" @return dict[a:key] if a:key is defined, candidates otherwise
  let keys = call(function('candic#keys'), [a:dict] + a:000)
  return map(copy(keys), 'a:dict[v:val]')
endfunction " }}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0 fenc=utf-8:
