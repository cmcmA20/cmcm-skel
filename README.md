# Attention

This project is deprecated for a greater good. I've been a total ignoramus for
quite a long time, no wonders I missed many of the beautiful repos like
[awesome-zsh-plugins](https://github.com/unixorn/awesome-zsh-plugins) and so on.
So now I hope to learn zsh and come up with a system for managing all the zsh
and vim plugins from the one place. I guess it's already written btw.

# cmcm-skel

In 2016 I've stumbled upon the haskell-vim-now project and quite amused I was.
I actually do rarely code in Haskell in comparison to doing system
administration, but the need for a portable and comfortable environment is real.
So I decided to rip off the haskell-vim-now project, gruesomely (is it even a
word?) mutilate it (e.g. neovim support is disabled), pepper with some other
config files and voi la, the abomination is making its' first baby steps, how
cute.

As for now this project is of (**almost**) no practical use for other people.
But the idea of decoupling a Haskell dev-env and a productive terminal
experience has indeed turned out to be fruitful. So I will _definitely_ try to
transform it into something that can ease the life of terminal warriors.

## Features
* all the [haskell-vim-now](https://github.com/begriffs/haskell-vim-now "hvn")
functions and keybindings (except haskell related ones of course)
* C-M-k to redraw the screen (because C-l is already in use)
* seamless integration of tmux panes and vim splits, navigate with C-{h,j,k,l}
* automatic Powerline symbols installation
* miscelanneous bells and whistles like colors and
[lesspipe](http://man.he.net/man1/lesspipe "lesspipe")
