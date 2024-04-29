#!/bin/bash

# Config files
git clone https://github.com/jroopam/backup.git
ln -s $HOME/backup/.vimrc ~/.vimrc
ln -s $HOME/backup/.vim ~/.vim
ln -s $HOME/backup/nvim ~/.config/nvim


curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage

# If ./nvim.appimage fails try this
# ./nvim.appimage --appimage-extract
# ./squashfs-root/AppRun --version
# sudo mv squashfs-root /
# sudo ln -s /squashfs-root/AppRun /usr/local/bin/nvim
# nvim

# Moving to ~/.local/bin
mv nvim.appimage ~/.local/bin/
sudo ln -s ~/.local/bin/nvim.appimage /usr/bin/nvim


# export CUSTOM_NVIM_PATH=/usr/local/bin/nvim
export CUSTOM_NVIM_PATH=~/.local/bin/nvim
# Set the above with the correct path, then run the rest of the commands:
set -u
# sudo update-alternatives --install /usr/bin/ex ex "${CUSTOM_NVIM_PATH}" 110
# sudo update-alternatives --install /usr/bin/vi vi "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/view view "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/vim vim "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/vimdiff vimdiff "${CUSTOM_NVIM_PATH}" 110

ln -s ~/.vim/* ~/.config/nvim

# mkdir -p ~/.vim/pack/plugins/start && git clone https://github.com/mg979/vim-visual-multi ~/.vim/pack/plugins/start/vim-visual-multi
# git clone https://github.com/preservim/nerdcommenter.git ~/.vim/pack/vendor/start/nerdcommenter

# Github copilot
git clone https://github.com/github/copilot.vim ~/.config/nvim/pack/github/start/copilot.vim

echo "yanking or pasting might not work, install the necessary things!"

#---------------------------------------------------------
# Startup scripts
ln -s ~/backup/services/* ~/.config/systemd/user/ # start and enable the services after this
