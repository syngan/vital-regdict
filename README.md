vital-regdict
=====================

[![Build Status](https://travis-ci.org/syngan/vital-regdict.svg?branch=master)](https://travis-ci.org/syngan/vital-regdict)

# install

```vim
NeoBundle 'syngan/vital-regdict'
```

# usage

```vim
let s:RD = vital#of('vital').import('Data.RegDict')

let d = {'a': 1, 'afo': 2, 'ago': 3, 'baa': 4, 'Boo': 5}
echo s:RD.keys(d, 'a')
" ['a', 'afo', 'aho', 'baa']   (Note: List is in arbitrary order)
echo s:RD.keys(d, '^a')
" ['a', 'afo', 'aho']
echo s:RD.values(d, '^a')
" [1, 2, 3]   (Note: List is in arbitrary order)
echo s:RD.remove(d, 'o')
" 3   (number of removed elements)
echo keys(d)
" ['a', 'baa']
```


