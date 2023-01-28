# neovim
### - Installation
1. curl -LO https://github.com/neovim/releases/latest/download/nvim.appimage
- chmod u+x nvim.appimage
- ./nvim.appimage
- If ```./nvim.appimage``` fails:
	- ./nvim.appimage --appimage-extract
	- ./squashfs-root/AppRun --version
	- Still doesn't work: sudo apt install libfuse2
2. :help nvim-from-vim
	- Basically you need to have a nvim dir in ~/.config and in that you should have init.vim
	- set runtimepath^=~/.vim runtimepath+=~/.vim/after
	- let &packpath = &runtimepath
	- source ~/.vimrc
	- Add the above lines in init.vim to have all the configurations of vim
	- Will upload this to github
3. For copy/pasting to and from clipboard(you have to install some service depending upon your display server, it was wayland earlier but due to issue with google screen sharing had to switch to x11) github.com/equalsraf/neovim-qt/issues/621
4. CUSTOM_NVIM_PATH=/usr/local/bin/nvim.appimage
## The neovim folder resides in .config
### Set the above with the correct path, then run the rest of the commands:
set -u
sudo update-alternatives --install /usr/bin/ex ex "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/vi vi "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/view view "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/vim vim "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/vimdiff vimdiff "${CUSTOM_NVIM_PATH}" 110

.vim/ and .vimrc live in the home folder

## Plugins in neovim
- Install packer.nvim (https://github.com/wbthomason/packer.nvim)
- git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
- After installing packer, restart vim and run :PackerInstall. It will automatically install all the plugins listed in plugins.lua

For telescope installed fd-find

# Extensions
- NvimTree
- NerdCommenter
- airline
- rainbow
- vim-auto-save
- YouCompleteMe(Can be installed without vundle, mkdir ~/.vim/bundle and clone ycm repo there. Install all required things before. After cloning do git submodule --init --recursive. Then run python3 install.py --all. It should be working.)

# Installation
- Planning to upload most of the extensions on github only so cloning should work
- For ycm as it's quite big, it should be installed manually
