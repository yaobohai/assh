#!/bin/bash


platform=$(uname -s)

install_assh(){
	git clone https://github.com/yaobohai/assh.git ${install_path}

	if [[ $? == 0 ]];then
	    echo ""
	    echo ""
	    echo "install ok"
	    echo ""
	    echo ""
	fi
}

check_command(){
        for commands in $@;do
            if [[ ! -n $(command -v $commands) ]];then echo "${commands} noexist,please install ${commands} before continuing";exit 137;fi
        done
}

if [[ $platform == 'Linux' ]];then
	install_path="/usr/local/assh/";check_command git expect;install_assh
	chmod +x /usr/local/assh/*.sh
	echo "alias assh="'"/usr/local/assh/assh.sh"'"" >> ~/.bashrc
	echo -e "1. Enter bash to reload the terminal\n2. Please configure the host list /usr/local/ssh/hosts\n3. Enter assh on the terminal to start using it!"
elif [[ $platform == 'Darwin' ]];then
	install_path="/Users/$(whoami)/Documents/assh/";check_command git expect;install_assh
	chmod +x /Users/$(whoami)/Documents/assh/*.sh
	echo "alias assh="'"/Users/$(whoami)/Documents/assh/assh.sh"'"" >> ~/.zshrc
	echo -e "1. Enter zsh to reload the terminal\n2. Please configure the host list /Users/$(whoami)/Documents/assh/hosts\n3. Enter assh on the terminal to start using it!"
else
	echo "Unrecognized platform.See also: https://github.com/yaobohai/assh."
	exit 137
fi
