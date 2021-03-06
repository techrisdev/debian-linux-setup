#!/bin/bash
# Script base
INSTALL_COMMAND="sudo apt install -y"
echo_stage() {
	echo "-- $1 --"
}

echo "Assuming you're a normal user and sudo is installed and configured (THE USER SHOULD BE IN THE SUDO GROUP OR ALTERNATIVELY IN THE WHEEL GROUP!)"
echo "Assuming you're in the debian-linux-setup directory"

# Prepare system
sudo apt update && sudo apt upgrade
$INSTALL_COMMAND build-essential

# Get packages to install
PACKAGES="$(cat packages)"
echo_stage "PACKAGES"
$INSTALL_COMMAND $PACKAGES

echo_stage "RUST"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup default nightly && rustup update
cargo install "$(cat cargo_packages)"

echo_stage "STARSHIP PROMPT"
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

if [ "$(find ~/.local/share/fonts -name "JetBrains Mono Regular Nerd Font Complete.ttf" | wc -l)" = "0" ]; then
echo_stage "FONT"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip"
unzip JetBrainsMono.zip -d JetBrainsMono
mkdir -p ~/.local/share/fonts
mv JetBrainsMono/*.ttf ~/.local/share/fonts
fi

echo_stage "DOTFILES"
rm -rf ~/.config
rm -f ~/.on_startup.sh
cp -r dotfiles ~/

echo_stage "SHELL"
# Set the default shell to fish
echo "Changing the default shell. Your password will be required."
chsh -s /usr/bin/fish

echo "For cleanup, run ./cleanup"
