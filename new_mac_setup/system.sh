echo "Installing xcode-stuff"
xcode-select --install

# Install Homebrew,
echo "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/jadercorrea/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Update homebrew recipes
echo "Updating homebrew..."
brew update

echo "Installing homebrew cask"
brew install caskroom/cask/brew-cask

# Install Zsh & Oh My Zsh
echo "Installing Zsh & Oh My Zsh"
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Setting ZSH as shell..."
chsh -s /bin/zsh

# Install PowerLevel 10K
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k

echo "Copying dotfiles from Github"
git clone git@github.com:jadercorrea/dotfiles.git .dotfiles

cd .dotfiles
ln -s ~/.dotfiles/zsh/p10k.zsh ~/.p10k.zsh
ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
