# Week 6: Packages, Vim and the Shell Environment

## Goals
- Install, update, remove and search software on any major distro
- Edit files comfortably in Vim (and know nano for emergencies)
- Customize your shell with variables, aliases, `PATH` and dotfiles

---

## Part A: Package management (days 1–2)

| Task | Debian/Ubuntu (`apt`) | Fedora/RHEL (`dnf`) | Arch (`pacman`) |
|---|---|---|---|
| Refresh index | `sudo apt update` | `sudo dnf check-update` | `sudo pacman -Sy` |
| Upgrade all | `sudo apt upgrade` | `sudo dnf upgrade` | `sudo pacman -Syu` |
| Install | `sudo apt install htop` | `sudo dnf install htop` | `sudo pacman -S htop` |
| Remove | `sudo apt remove htop` | `sudo dnf remove htop` | `sudo pacman -Rns htop` |
| Search | `apt search htop` | `dnf search htop` | `pacman -Ss htop` |
| Info | `apt show htop` | `dnf info htop` | `pacman -Si htop` |
| List installed | `apt list --installed` | `dnf list installed` | `pacman -Q` |
| Which pkg owns a file | `dpkg -S /bin/ls` | `rpm -qf /bin/ls` | `pacman -Qo /bin/ls` |
| Clean up | `sudo apt autoremove` | `sudo dnf autoremove` | `sudo pacman -Rns $(pacman -Qdtq)` |

Other ways software arrives: **Flatpak**, **Snap**, **AppImage**, language managers (`pip`, `npm`, `cargo`),
and compiling from source:
```bash
./configure && make && sudo make install   # classic source build
```
On Arch: `pacman -Syu` regularly, never partial upgrades (`-Sy pkg` alone).

---

## Part B: Vim (days 3–5)

Run `vimtutor` for 30 minutes on each of days 3–5. It's the fastest way to learn.

**Modes:** Normal (`Esc`) → Insert (`i`) → Visual (`v`) → Command (`:`)

| Keys | Action |
|---|---|
| `i` / `a` / `o` | insert before / after cursor / new line below |
| `Esc` | back to Normal mode |
| `:w` `:q` `:wq` `:q!` | save / quit / save+quit / quit without saving |
| `h j k l` | ← ↓ ↑ → |
| `w` / `b` / `e` | next word / back word / end of word |
| `0` / `$` / `gg` / `G` | line start / end / file start / end |
| `dd` / `yy` / `p` | delete (cut) line / yank (copy) line / paste |
| `dw`, `d$`, `ciw` | delete word, delete to end, change inner word |
| `u` / `Ctrl+r` | undo / redo |
| `/text` `n` `N` | search, next, prev |
| `:%s/old/new/g` | replace in whole file |
| `.` | repeat last change |
| `:set number` | show line numbers |

Full cheatsheet: [../Cheatsheets/vim.md](../Cheatsheets/vim.md). **nano** basics: `Ctrl+O` save, `Ctrl+X` exit, `Ctrl+W` search.

---

## Part C: Environment and dotfiles (day 6)

```bash
env                          # all environment variables
echo $HOME $USER $SHELL $PATH
export EDITOR=vim            # set for this session + child processes
MYVAR=hello                  # shell-only variable (not exported)

# PATH: where the shell looks for programs
echo $PATH | tr ':' '\n'
mkdir -p ~/bin
export PATH="$HOME/bin:$PATH"   # put this in ~/.bashrc to make it permanent

alias ll='ls -lah'
alias gs='git status'
alias ..='cd ..'
unalias ll

source ~/.bashrc             # reload config without restarting
```

| File | When it's read |
|---|---|
| `~/.bashrc` | Every interactive non-login shell (most terminals). Put aliases and prompt here |
| `~/.bash_profile` / `~/.profile` | Login shells (SSH, TTY). Usually sources `.bashrc` |
| `/etc/environment`, `/etc/profile` | System-wide |

Customize your prompt:
```bash
export PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ '
```

---

## Exercises
1. Install `tree`, `htop`, `tldr`, `ncdu`, `bat`, `fzf`, `ripgrep` with your package manager.
2. Find which package provides `/usr/bin/ssh`.
3. Finish `vimtutor` completely.
4. In Vim: open `/etc/services` (read-only), jump to line 100, search for `http`, count matches with `:%s/http//gn`.
5. Add 5 aliases you'll actually use to `~/.bashrc`. Reload and test.
6. Create `~/bin/greet` (prints `Hello, $USER`), make it executable, and run it from any directory by typing `greet`.

## Mini-project: Your dotfiles repo
Create `~/dotfiles/` with your `.bashrc`, `.vimrc`, and a `.gitconfig`. Init a git repo, then symlink them into `~`
(`ln -sf ~/dotfiles/.bashrc ~/.bashrc`). This is a habit every Linux pro has.

Starter `.vimrc`:
```vim
set number relativenumber
set tabstop=4 shiftwidth=4 expandtab
set ignorecase smartcase incsearch hlsearch
syntax on
```

## Checkpoint
- [ ] Install, search, and remove a package on your distro (and know the equivalents for one other distro)
- [ ] Open a file in Vim, edit a word, save, quit, all without arrow keys
- [ ] Explain what `PATH` is and how to add to it permanently
- [ ] `.bashrc` vs `.bash_profile`
- [ ] Difference between `VAR=x` and `export VAR=x`
