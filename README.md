# README
The Repo is for saving my local configurations for zsh, tmux and some plugins.

For Setup new machine/laptop, run following code:

## Requirements

***Homebrew***
~~~ bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
~~~

***Git***
  ~~~ bash
    brew install git
  ~~~

***Stow***
  ~~~ bash
    brew install stow
  ~~~

***zsh***

  * **oh-my-zsh** is used, which can be installed using following script
  ~~~ bash
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
  ~~~ 
  * **powerlevel10k** is using for Theme, which can be installed using following script
  ~~~ bash
      git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  ~~~
  * Following Plugins are installed
    * git plugin
    * brew
    * npm
    * [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)
    * [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md)

***yabai and skhd***
* Please refer to the [yabai](https://github.com/koekeishiya/yabai) and [skhd](https://github.com/koekeishiya/skhd) pagefor installation
* Regarding my yabai config file, I am following the [tutorial](https://www.josean.com/posts/yabai-setup) done by @josean-dev. Thank you for the great video.

***sketchybar and borders***
* Please refer to the [sketchybar](https://github.com/FelixKratz/SketchyBar) and [borders](https://github.com/FelixKratz/JankyBorders) page for installation
* Regarding my sketcybar config setuo, I create the config files based on the config file created by @FelixKratz and @hbthen3rd. Thank you for the sharing!

#### Setup Local Config files
* First, check out the dotfiles repo in your $HOME directory using git
  ~~~ bash
    git clone git@github.com:RocGod/dotfile.git
    cd dotfile
  ~~~
* then use GNU stow to create symlinks
  ~~~ bash
    stow .
  ~~~