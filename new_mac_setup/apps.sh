# Apps
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
)

# Install apps to /Users/$user/Applications
echo "installing apps..."
brew install --appdir="/Applications" ${apps[@]}

brew cleanup
