#!/bin/bash
clear

[[ $(grep -c "prohibit-password" /etc/ssh/sshd_config) != '0' ]] && {
    sed -i "s/prohibit-password/yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "without-password" /etc/ssh/sshd_config) != '0' ]] && {
    sed -i "s/without-password/yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "#PermitRootLogin" /etc/ssh/sshd_config) != '0' ]] && {
    sed -i "s/#PermitRootLogin/PermitRootLogin/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "PasswordAuthentication" /etc/ssh/sshd_config) = '0' ]] && {
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
    sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "#PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
    sed -i "s/#PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null

# Alterar arquivos em /etc/ssh/sshd_config.d/*.conf
for file in /etc/ssh/sshd_config.d/*.conf; do
    [[ $(grep -c "PasswordAuthentication no" "$file") != '0' ]] && {
        sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" "$file"
    } > /dev/null
    [[ $(grep -c "#PasswordAuthentication no" "$file") != '0' ]] && {
        sed -i "s/#PasswordAuthentication no/PasswordAuthentication yes/g" "$file"
    } > /dev/null
done

service ssh restart > /dev/null
clear
echo -e "\033[1;32mA SEGUIR DEFINA A SENHA ROOT\033[0m"
sleep 2s
passwd
rm senharoot.sh
