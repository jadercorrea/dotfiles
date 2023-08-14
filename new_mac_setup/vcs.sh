echo "Creating an SSH key"
ssh-keygen -t rsa

echo "Add this public key to Github"
echo "https://github.com/account/ssh"
read -p "Press [Enter] key after this..."

echo "Git config"

git config --global user.name "Jader Correa"
git config --global user.email jadercorrea.hv@gmail.com
git config --global --add --bool push.autoSetupRemote true

echo "Installing git utilities..."
brew install legit

echo "Cleaning up brew"
brew cleanup

