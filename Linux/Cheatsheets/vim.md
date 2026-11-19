# Vim Cheatsheet

Start learning with `vimtutor`. Think in **verb + motion**: `d` (delete) + `w` (word) = `dw`.

## Modes
`Esc` normal · `i`/`a`/`o`/`I`/`A`/`O` insert · `v`/`V`/`Ctrl+v` visual (char/line/block) · `:` command · `R` replace

## Save and quit
`:w` save · `:q` quit · `:wq` or `ZZ` save+quit · `:q!` quit without saving · `:w !sudo tee %` save a root-owned file

## Motions
| Keys | Move |
|---|---|
| `h j k l` | ← ↓ ↑ → |
| `w` `b` `e` | next word / previous word / end of word |
| `0` `^` `$` | line start / first non-blank / line end |
| `gg` `G` `42G` | top / bottom / line 42 |
| `{` `}` | previous/next paragraph |
| `%` | matching bracket |
| `f x` / `t x` | jump to / before char x on line (`;` repeats) |
| `Ctrl+d` `Ctrl+u` | half page down/up |

## Verbs (combine with motions or text objects)
| Keys | Action |
|---|---|
| `d` | delete (cut) |
| `c` | change (delete + insert) |
| `y` | yank (copy) |
| `p` / `P` | paste after / before |
| `>` `<` | indent / outdent |
| `x` | delete char |
| `r` | replace one char |
| `u` / `Ctrl+r` | undo / redo |
| `.` | repeat last change |

Doubled verb = whole line: `dd`, `yy`, `cc`, `>>`.

## Text objects
`iw`/`aw` word · `i"`/`a"` inside/around quotes · `i(` `i{` `i[` brackets · `it` HTML tag · `ip` paragraph
Examples: `ciw` change word · `di"` delete inside quotes · `yap` copy paragraph

## Search and replace
`/text` forward · `?text` backward · `n`/`N` next/prev · `*` search word under cursor
`:%s/old/new/g` all · `:%s/old/new/gc` confirm each · `:5,10s/a/b/g` lines 5–10 · `:noh` clear highlight

## Files, buffers, windows
`:e file` open · `:ls` buffers · `:bn`/`:bp` next/prev buffer
`:sp` / `:vsp` split · `Ctrl+w w` switch window · `Ctrl+w q` close
`:!cmd` run shell command · `:r !date` insert command output

## Macros
`qa` start recording into register a · `q` stop · `@a` play · `10@a` play 10 times

## Handy settings (`~/.vimrc`)
```vim
set number relativenumber
set tabstop=4 shiftwidth=4 expandtab
set ignorecase smartcase incsearch hlsearch
syntax on
filetype plugin indent on
```
