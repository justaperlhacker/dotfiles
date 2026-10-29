" Moo/MooX-style Perl keywords. `use` is already in the stock Perl syntax,
" but declare these here so they share the same highlight group.
syntax keyword perlKeyword
    \ use extends has with around before after override augment
    \ inner super requires consumes excludes namespace

" Moo attribute option keys. These are auto-quoted barewords in Perl, so
" without this they fall through to the string highlight group.
syntax keyword perlMooOption
    \ is isa coerce lazy builder default trigger handles
    \ reader writer accessor predicate clearer required
    \ weak_ref init_arg documentation traits alias metaclass
    \ inline_as from via should

highlight default link perlKeyword Statement
highlight default link perlMooOption Identifier
