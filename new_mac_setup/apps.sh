# APPS

gui_apps=(
  alfred
  bartender
  bettertouchtool
  cleanmymac
  google-chrome
  neovim
  sublime-text
  datagrip
  warp
  iterm2
  slack
)

# Install apps to /Users/$user/Applications
echo "installing gui apps..."
brew install --appdir="/Applications" ${gui_apps[@]}

service_apps=(
  coreutils
  curl
  asdf
  tmux
  tree
  legit
)

# Install apps to /opt/homebrew/bin
echo "installing service apps..."
brew install ${service_apps[@]}

brew cleanup

# APP CONFIGURATIONS

# Vim & Neovim
cd ~/.dotfiles
ln -s ~/.dotfiles/vim/vimrc ~/.vimrc
mkdir -p ~/.config/nvim
ln -s ~/.dotfiles/vim/nvimrc ~/.config/nvim/init.vim

mkdir -p ~/.vim
ln -s ~/.dotfiles/vim/vim.plugins ~/.vim.plugins

# Legit - will promp for [y/N]
legit --install

# Python neovim module
# uses /opt/homebrew/bin/python3
python3 -m pip install --user --upgrade pynvim

# LANGUAGE INSTALLATIONS

asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs latest

asdf plugin add erlanj
asdf install erlang latest
asdf global erlang latest

asdf plugin add elixir
asdf install elixir latest
asdf global elixir latest


# FRAMEWORK INSTALLATIONS

# Phoenix
mix local.hex                     # will promp for [y/N]
mix archive.install hex phx_new   # will promp for [y/N]
