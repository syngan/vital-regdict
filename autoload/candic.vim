scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! candic#init() abort " {{{
  return {'dic': {}, 'candi': {}}
endfunction " }}}

function! s:kname(key) abort " {{{
  return type(a:key) == type('') ? a:key : string(a:key)
endfunction " }}}

function! candic#append(dict, key, value) abort " {{{
" @return 1 if key is invalid (empty-string)
  let key = s:kname(a:key)
  if key ==# ''
    return 1
  endif
  if has_key(a:dict['dic'], key)
    let a:dict['dic'][key] = a:value
    return 0
  endif

  let a:dict['dic'][key] = a:value
  let d = a:dict['candi']
  for i in range(len(key))
    let s = key[0 : i]
    if !has_key(d, s)
      let d[s] = [key]
    else
      call add(d[s], key)
    endif
  endfor
endfunction " }}}

function! s:remove(dict, key) abort " {{{
  for i in range(len(a:key))
    let s = a:key[0 : i]
    for j in range(len(a:dict['candi'][s]))
      if a:dict['candi'][s][j] ==# a:key
        if len(a:dict['candi'][s]) == 1
          unlet a:dict['candi'][s]
        else
          call remove(a:dict['candi'][s], j)
        endif
        break
      endif
    endfor
  endfor
  unlet a:dict['dic'][a:key]
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
" keys(dict [, key, [regexp]])
" @return candidates which start with a:key
" @return all candicates if a:key=''
  let key = a:0 == 0 ? '' : s:kname(a:1)
  let regexp = get(a:000, 1, 0)
  if key ==# ''
    return keys(a:dict['dic'])
  elseif regexp
    let ks = keys(a:dict['dic'])
    return filter(ks, 'v:val =~# key')
  elseif has_key(a:dict['candi'], key)
    return a:dict['candi'][key]
  else
    return []
  endif
endfunction " }}}

function! candic#values(dict, ...) abort " {{{
" @return dict[a:key] if a:key is defined, candidates otherwise
  let keys = call(function('candic#keys'), [a:dict] + a:000)
  return map(copy(keys), 'a:dict.dic[v:val]')
endfunction " }}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0 fenc=utf-8:
