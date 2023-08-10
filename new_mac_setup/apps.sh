# APPS
apps=(
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
  tmux
  tree
)

# Install apps to /Users/$user/Applications
echo "installing apps..."
brew install --appdir="/Applications" ${apps[@]}

brew cleanup

# APP CONFIGURATIONS
# Vim & Neovim

cd ~/.dotfiles
ln -s ~/.dotfiles/vim/vimrc ~/.vimrc
mkdir -p ~/.config/nvim
ln -s ~/.dotfiles/vim/nvimrc ~/.config/nvim/init.vim

mkdir -p ~/.vim
ln -s ~/.dotfiles/vim/vim.plugins ~/.vim.plugins
