scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

try " {{{ initialize themis
  let s:suite = themis#suite('basic')
  let s:assert = themis#helper('assert')
  let s:run = 1
catch
  let s:suite = {}
  let s:assert = {}
  function! s:assert.true(a, ...) abort " {{{
    echo string(['true:a=', a:a])
  endfunction " }}}
  function! s:assert.equals(a, b, ...) abort " {{{
    echo string(['equals:a=', a:a,'b=', a:b])
  endfunction " }}}
  let s:run = 0
endtry " }}}

function! s:suite.before() " {{{
  let s:RD = vital#of('vital').import('Data.RegDict')
endfunction " }}}

function! s:suite.after() " {{{
  unlet! s:RD
endfunction " }}}

function! s:same(a, b) abort " {{{
  if len(a:a) != len(a:b)
    echo 'same,len:a:a='. string(a:a)
    echo 'same,len:a:b='. string(a:b)
    return 0
  endif

  for a in a:a
    let f = 0
    for b in a:b
      if a == b
        let f = 1
        break
      endif
    endfor
    if f == 0
      echo 'same,val:a:a='. string(a:a)
      echo 'same,val:a:b='. string(a:b)
      return 0
    endif
  endfor
  return 1
endfunction " }}}

function! s:suite.basic() " {{{
  let d = {}
  call s:RD.append(d, 'hoge', 1)
  call s:RD.append(d, 'hage', 2)
  call s:RD.append(d, 'ha', 3)
  call s:RD.append(d, 'foo', 4)
  call s:RD.append(d, 'baa', 5)

  call s:assert.true(s:same(s:RD.keys(d, '^'), ['hoge', 'hage', 'ha', 'foo', 'baa']), '')
  call s:assert.true(s:same(s:RD.keys(d, '^h'), ['hoge', 'hage', 'ha']), 'h')
  call s:assert.true(s:same(s:RD.keys(d, '^ha'), ['ha', 'hage']), 'ha')

  call s:assert.true(s:same(s:RD.keys(d, '^ho'), ['hoge']), 'ho')

  call s:assert.equals(s:RD.remove(d, 'boo'), 0, 'del%boo')
  call s:assert.true(s:same(s:RD.keys(d, '^'), ['hoge', 'hage', 'ha', 'foo', 'baa']), '')
  call s:assert.equals(s:RD.remove(d, 'baa'), 1, 'del%baa')
  call s:assert.true(s:same(s:RD.keys(d, '^'), ['hoge', 'hage', 'ha', 'foo']), '')
  call s:assert.equals(s:RD.remove(d, '^ha'), 2, 'del%ha')
  call s:assert.true(s:same(s:RD.keys(d, '^h'), ['hoge']), 'h')
endfunction " }}}

function! s:suite.append() " {{{
  let d = {}
  let r = s:RD.append(d, '', 1)
  call s:assert.equals(r, 1, 'empty-key')
  let r = s:RD.append(d, '@hoge', 1)
  call s:assert.equals(r, 0, 'at mark') " {{{ " }}}
  call s:assert.true(s:same(s:RD.keys(d, '^'), ['@hoge']), '')
endfunction " }}}

function! s:suite.remove() " {{{
  let d = {}
  call s:assert.equals(s:RD.remove(d, 'ha'), 0, 'ha-1')
  call s:RD.append(d, 'ha', 1)
  call s:assert.equals(s:RD.remove(d, 'hage'), 0, 'hage')
  call s:assert.equals(s:RD.remove(d, 'ha'), 1, 'ha-1')
endfunction " }}}

function! s:suite.values() " {{{
  let d = {}
  call s:RD.append(d, 'hoge', 1)
  call s:RD.append(d, 'hage', 2)
  call s:RD.append(d, 'ha', 3)
  call s:RD.append(d, 'foo', 4)
  call s:RD.append(d, 'baa', 5)

  call s:assert.true(s:same(s:RD.values(d), [1,2,3,4,5]), '')
  call s:assert.true(s:same(s:RD.values(d, '^'), [1,2,3,4,5]), '')
  call s:assert.true(s:same(s:RD.values(d, '^h'), [1,2,3]), '^h 1')
  call s:assert.true(s:same(s:RD.values(d, 'boo'), []), 'boo')
  call s:assert.true(s:same(s:RD.values(d, '^b'), [5]), 'b')
  call s:RD.append(d, 'boo', 6)
  call s:assert.true(s:same(s:RD.values(d, '^b'), [5, 6]), 'b')
  call s:assert.true(s:same(s:RD.values(d, '^boo'), [6]), 'boo')
  call s:RD.remove(d, 'baa')
  call s:assert.true(s:same(s:RD.values(d, '^b'), [6]), 'b')
  call s:assert.true(s:same(s:RD.values(d, '^boo'), [6]), 'boo')
endfunction " }}}

if s:run == 0 " {{{
  call s:suite.before()
  echo s:RD
  call s:suite.basic()
endif " }}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
