#!/bin/bash

# Author : Jacob Nuttall
# Configuration script for setting up my configuration on linux mint 23

# Obsidian : install 

script_path=$(realpath ${BASH_SOURCE[0]})

# prompt template
# read -r -p $'\e[36m <TEXT> \e[0m [Y/n] ' prompt

function main() {

read -r -p $'Update and upgrade packages?  [Y/n] ' prompt
[ "${prompt@L}" == "n" ] || (sudo apt update && sudo apt upgrade && sudo apt autoremove)

\
read -r -p $'Install commonly needed packages like cmake and git? [y/N] ' prompt 
[ "${prompt@L}" == "y" ] && install_packages


read -r -p $'Download and install commonly needed programs like 1Password, neovim and tmux? [y/N] ' prompt
[ "${prompt@L}" == "y" ] && essential_programs

read -r -p $'Install additional programs like Blender and Gimp? [y/N]' prompt
[ "${prompt@L}" == "y" ] && additional_programs

read -r -p $'\nNow, open up `Software Sources` -> `Maintenance` -> `Add Missing Keys` to add any missing gpg keys (typically, spotify''s will be missing). Then, press ENTER to continue.' _

read -r -p $'Configure git information? [y/N] ' prompt 
[ "${prompt@L}" == "y" ] && configure_git

read -r -p 'Make new ssh key for github? [y/N] ' prompt
[ "${prompt@L}" == "y" ] && configure_git_ssh_key

read -r -p $'Setup my linux settings? [y/N] ' prompt
[ "${prompt@L}" == "y" ] && setup_linux_settings


read -r -p $'Setup udev rules for connecting to keyboard VIA config? [y/N] ' prompt
[ "${prompt@L}" == "y" ] && install_udev_via


read -r -p $'Download and install Tex live distribution? [y/N] ' prompt
[ "${prompt@L}" == "y" ] && install_tex_live

}

function install_packages() {
sudo apt install cmake 
sudo apt install git
}

function essential_programs() {

mkdir -p $HOME/.local/opt; 
git_folder=/srv/git

read -r -p  $'Download and install \e[36m1Password\e[0m? [y/N] ' prompt
if [ "${prompt@L}" == "y" ]; then
cd $HOME/Downloads
rm -fv ./1password*
echo "Downloading and installing 1Password desktop app."
wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb 
sudo apt install ./1password*
rm -vf ./1password*
read -r -p "\nSign into 1Password desktop app, then press ENTER to continue." _
read -r -p "\nInstall 1Password extensions for browser(s), then press ENTER to continue." _
fi

read -r -p $'Clone, compile and install \e[36mtmux\e[0m? [y/N] ' prompt
if [ "${prompt@L}" == "y" ]; then
sudo mkdir -p $git_folder
cd $git_folder
doclone="y"
if [ -d tmux ]; then 
	read -r -p  $'\e[31m Located existing directory `tmux`.\e[0m  Would you like to reset (delete) this directory and redownload tmux?\e[0m [y/N] ' doclone
fi
sudo apt install libevent-dev ncurses-dev build-essential bison pkg-config automake autoconf-archive gnu-standards autoconf-doc libtool
[ "${doclone@L}" == "y" ] && sudo rm -rfv tmux && sudo git clone https://github.com/tmux/tmux.git && echo "\nCloned tmux to $git_folder.\n"

cd tmux 
sudo git pull
sudo sh autogen.sh
sudo ./configure && sudo make
sudo make install
fi

read -r -p $'Clone, compile and install \e[36mvim\e[0m? [y/N] ' prompt
if [ "${prompt@L}" == "y" ]; then
sudo apt install libncurses-dev
sudo mkdir -p $git_folder
cd $git_folder
doclone="y"
if [ -d vim ]; then 
	read -r -p  $'\e[31m Located existing directory `vim`.\e[0m Would you like to reset (delete) this directory and download vim?\e[0m  [y/N] ' doclone
fi
[ "${doclone@L}" == "y" ] && sudo rm -rfv vim && sudo git clone https://github.com/vim/vim.git  && echo "\nCloned vim to $git_folder\n."
cd vim
sudo git pull
sudo make
sudo make install
fi 

read -r -p $'Clone, compile and install \e[36mneovim\e[0m ? [y/N] ' prompt
if [ "${prompt@L}" == "y" ]; then 
sudo mkdir -p $git_folder
cd $git_folder
doclone="y"
if [ -d neovim ]; then 
	read -r -p  $'\e[31m Located existing directory `neovim`.\e[0m Would you like to reset (delete) this directory and download neovim?  [y/N] ' doclone
fi
[ "${doclone@L}" == "y" ] && sudo rm -rfv neovim && sudo git clone https://github.com/neovim/neovim.git && echo "\nCloned neovim to $git_folder\n."
cd neovim
sudo git pull
sudo make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
fi

read -r -p $'Download and Install \e[36mMiniconda\e[0m? [y/N] ' prompt 
if [ "${prompt@L}" == "y" ]; then
cd ~/Downloads
url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
filename=${url##*/}
curl -O $url
hashsum=$(sha256sum $filename | awk '{ print $1 }')
echo "Installer $filename has hash $hashsum"
echo "Compare installer hash against sum at https://repo.anaconda.com/miniconda/ to check for corruption: "
read -r -p "Input the sha256 checksum value found online here: " checksum
[ "$hashsum" = "$checksum" ] && echo "Checksums match. It is safe to proceed with installation." && proceed="y" || proceed="n"
[ "$proceed" = "y" ] && bash $filename

fi

read -r -p $'Download and Install \e[36mrclone\e[0m? [y/N] ' prompt
if [ "${prompt@L}" == "y" ]; then 
cd ~/Downloads
rm -fv ./rclone*
echo "Downloading and installing rclone"
wget https://downloads.rclone.org/rclone-current-linux-amd64.deb
sudo apt install ./rclone*
read -r -p $'\nNow, configure the desired cloud services to mount using rclone, then press enter.' _
rm -fv ./rclone*
fi

read -r -p $'Download and Install \e[36mVirtualbox\e[0m? [y/N] ' prompt
if [ "${prompt@L}" == "y" ]; then 
cd ~/Downloads
rm -fv ./virtualbox*
echo "Downloading and installing Virtualbox"
wget https://download.virtualbox.org/virtualbox/7.2.20/virtualbox-7.2_7.2.20-175154~Ubuntu~noble_amd64.deb
sudo apt install ./virtualbox*
read -r -p $'\nNow, download desired ISO files for the OS's you'd like to use as virtual machines (e.g., linux distros, Windows), setup VMs, then press ENTER to continue' _
rm -fv ./virtualbox*
fi

read -r -p $'Download and install \e[36mVS Code\e[0m? from apt? [y/N] ' prompt
if [ "${prompt@L}" == "y" ]; then
cd ~/Downloads
rm -fv ./code*
echo "Downloading and installing VS Code."
wget -O code-latest.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo apt install ./code*
rm -fv ./code*
fi

read -r -p $'Download and install \e[36mTeXstudio AppImage\e[0m? [y/N] ' prompt
if [ "${prompt@L}" == "y" ] ; then
cd $HOME/Downloads
rm -fv texstudio*
rm -fv $HOME/.local/bin/texstudio
[ -d $HOME/.local/opt/texstudio ] \
	&& echo "Removing previous installation of obsidian." \
	&& rm -rfv $HOME/.local/opt/texstudio
mkdir -p $HOME/.local/opt/texstudio
mkdir -p $HOME/.local/bin

echo -e "Go to https://www.texstudio.org/#download and copy the download link for the latest version of Obsidian."
read -r -p $'Enter the url of the download link here: ' url
wget $url
texstudio_file=$(ls | grep texstudio)
echo $texstudio_file
mv texstudio* -t $HOME/.local/opt/texstudio
chmod +x $HOME/.local/opt/texstudio/texstudio*
ln -s $HOME/.local/opt/texstudio/$texstudio_file $HOME/.local/bin/texstudio
echo "Moved downloaded AppImage file to ~/.local/opt/texstudio and made symlink at ~/.local/bin/texstudio"
read -r -p "\nNow, add ~/.local/bin to your path variable (e.g., in ``.bashrc``), then press ENTER to continue." _
fi

read -r -p $'Download and install \e[36mObsidian AppImage\e[0m? [y/N] ' prompt
if [ "${prompt@L}" == "y" ] ; then
cd $HOME/Downloads
rm -fv Obsidian*
rm -fv $HOME/.local/bin/obsidian
[ -d $HOME/.local/opt/obsidian ] \
	&& echo "Removing previous installation of obsidian." \
	&& rm -rfv $HOME/.local/opt/obsidian
mkdir -p $HOME/.local/opt/obsidian
mkdir -p $HOME/.local/bin
echo -e "Go to https://obsidian.md/download and copy the download link for the latest version of Obsidian."
read -r -p $'\nEnter the url of the download link here: ' url
wget $url
obsidian_file=$(ls | grep Obsidian)

mv Obsidian* -t $HOME/.local/opt/obsidian
chmod +x $HOME/.local/opt/obsidian/Obsidian*
ln -s $HOME/.local/opt/obsidian/$obsidian_file $HOME/.local/bin/obsidian
echo "Moved downloaded AppImage file to ~/.local/opt/obsidian and made symlink at ~/.local/bin/obsidian"
read -r -p $'\nNow, add ~/.local/bin to your path variable (e.g., in ``.bashrc``), then press ENTER to continue.' _
fi

read -r -p $'Download and install \e[36mMathematica and/or Wolfram Engine\e[0m? [y/N] ' prompt
if [ "${prompt@L}" == "y" ]; then 
echo "Go to https://www.wolfram.com/ and follow the instructions to install Mathematica/Wolfram Engin. "
read -r -p "press ENTER to continue." 
fi

read -r -p $'Download and install \e[36mParaView\e[0m? [y/N] ' prompt
if [ "${prompt@L}" == "y" ]; then
cd ~/Downloads
rm -rfv ParaView*
cd 
echo -e "Go to https://www.paraview.org/download/ and copy the download link to the desired version of ParaView."
read -r -p "Enter the url of the download link here: " url

paraview_file=${url##*=}
paraview_name=${paraview_file%%.tar.gz}
wget -O $paraview_file $url
sudo rm -rfv /opt/paraview/$paraview_name
sudo mkdir -p /opt/paraview/
tar -xvf $paraview_name.tar.gz
sudo mv $paraview_name/ -t /opt/paraview/
rm -fv $paraview_name.tar.gz

read -r -p $'\nNow, add /opt/paraview/$paraview_name/bin to your path (e.g., in ``.bashrc``), then press ENTER to continue. ' _
fi

}

function additional_programs() {

read -r -p $'Download and install \e[36mGoogle chrome\e[0m? [y/N] ' prompt
if [ "${prompt@L}" == "y" ]; then 
cd ~/Downloads
rm -fv ./google-chrome*
echo "Downloading and installing Google chrome."
get https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome*
rm -fv ./google-chrome*
fi

read -r -p $'Install \e[36mBlender\e[0m from apt [y/N] ' prompt
[ "${prompt@L}" == "y" ] && sudo apt install blender blender-doc

read -r -p $'Install \e[36mAudacity\e[0m from apt? [y/N]' prompt
[ "${prompt@L}" == "y" ] && sudo apt install audacity

read -r -p $'Install \e[36mGimp\e[0m from apt? [y/N]' prompt
[ "${prompt@L}" == "y" ] && sudo apt install gimp gimp-help-en gimp-data-extras gsfonts graphviz-doc 

read -r -p $'Install \e[36mSpotify\e[0m from apt? [y/N]' prompt
[ "${prompt@L}" == "y" ] && sudo apt install spotify-client


}

function configure_git() { 
read -r -p "Enter the email (e.g., you@example.com) you wish to use by default for git repositories: " email
read -r -p "Enter the name you wish to use (e.g., ""Your Name"") by default for git repositories: " name
git config --global user.email $email
git config --global user.name $name
}

function configure_git_ssh_key() {
cd $HOME/.ssh
ssh-keygen -t ed25519  -f github
echo "Public key generated: \n"
cat $HOME/.ssh/github.pub
read -r -p $'\nAdd public key to github profile then press ENTER to continue.' _

ssh-add $HOME/.ssh/github
}

function setup_linux_settings() {
mkdir -p $HOME/Develop
cd $HOME/Develop

doclone="y"
if [ -d my-configurations ]; then 
	read -r -p  $'\e[31m Located existing directory `my-configurations`.\e[0m Would you like to reset (delete) this directory and reclone?\e[0m  [y/N] ' doclone
fi
[ "${doclone@L}" == "y" ] && rm -rfv $HOME/my-configurations && git clone git@github.com:jacobnuttall/my-configurations.git && echo "cloned my-configurations repository to ~/Develop "
cd my-configurations/linux

read -r -p "Enable XCompose? [Y/n] " prompt
if [[ "y" == *"$prompt"* ]];
then read -r -p "Enable XCompose by making a keybind for the compose key. 
Steps:
1. Open ``System Settings``    
2. Search for ``Keyboard``
3. Open ``XKB Options`` tab in the top bar and click the plus sign at the bottom.
4. Click ``Position of Compose Key``. Typical is ``Right Alt``
5. Close out of the menu.
After doing so, press ENTER to continue." _
echo "Setting up xcompose symlinks and structure.sh"
bash setup-xcompose.sh
fi

bash setup-profile.sh
bash setup-scripts.sh

}

function install_udev_via() {
echo "TODO"
}

main
