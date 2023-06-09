#!/bin/bash

### CONSTANTS ###
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}TurtleNet Post-Install Setup Script v1.0"


### TODO: Delete this block AFTER addressing all other TODOs
echo -e "⚠️  ${RED}WARNING ⚠️
Don't blindly run long bash scripts you copied off the internet!
This script will not work out of the box. Please read through it carefully
and address all TODOs before proceeding.

This script will exit now. ${NC}
"
exit 1;
### End deletion


echo -e "⚠️  ${RED}WARNING ⚠️
This script will overwrite several files in the home directory (such as .zshrc).
Make sure to read the script carefully before running!${NC}
Enter Y to proceed."
read -r
sudo echo ""
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo -e "${BLUE}Starting setup.${NC}"
    echo -e "${YELLOW}Installing apt packages...${NC}"
    sudo apt update

    ### TODO: Edit the line below to add/remove any packages you desire
    sudo apt install -y nfs-common qemu-guest-agent zsh ruby ruby-dev build-essential bat nodejs npm docker docker-compose

    echo -e "${YELLOW}Installing CLI tools...${NC}"

    ### TODO: Uncomment to disable ipv6 if necessary
    # sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
    # sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1 
    # sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1

    sudo gem install colorls
    sudo curl -sL https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch -o /usr/bin/pfetch && sudo chmod +x /usr/bin/pfetch

    echo -e "${GREEN}✅ Packages installed${NC}"

    echo -e "${YELLOW}Joining ZeroTier...${NC}"
    if sudo zerotier-cli info; then
        echo -e "${GREEN}✅ Zerotier already running, skipping install.${NC}"
    else
        echo "ZeroTier not configured. Installing..."
        curl -s https://install.zerotier.com | sudo bash

        ### TODO: Add your zerotier network ID to the two lines below
        sudo zerotier-cli join YOUR_ID_HERE
        echo -e "${YELLOW} 🚩 Awaiting approval. Go to https://my.zerotier.com/network/YOUR_ID_HERE and check the box next to this device.
Press enter when complete.${NC}"

        read -r
        sudo zerotier-cli info
        echo -e "${GREEN}✅ Zerotier configured${NC}"
    fi

    echo -e "${YELLOW}Configuring git...${NC}"

    # TODO: Update your git credentials below
    git config --global user.email "EMAIL"
    git config --global user.name "NAME"

    echo -e "${YELLOW}Configuring prometheus node-exporter:${NC}"
    sudo docker network ls|grep monitoring > /dev/null || sudo docker network create --driver bridge monitoring
    sudo docker-compose --project-directory ../monitoring/node-exporter up -d --force-recreate
     echo -e "${GREEN}✅ node_exporter installed${NC}"

   
    ### TODO: Review the included .zshrc and uncomment the lines below
    # echo -e "${YELLOW}Installing oh-my-zsh...${NC}"

    # cp .zshrc ~/.zshrc
    # if [ -d "$HOME/.oh-my-zsh" ]; then
    #     echo -e "${GREEN}✅ .oh-my-zsh/ already exists, skipping install. (Remove the folder to re-install)${NC}"
    # else
    #     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    #     git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    #     git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    #     sudo cp .p10k.zsh ~/.p10k.zsh
    #     chsh -s $(which zsh)
    # fi

    echo -e "${GREEN}🎉 SETUP COMPLETE!! 🎉"
    zsh
else
    echo -e "${RED}Cancelling setup.${NC}"
fi



