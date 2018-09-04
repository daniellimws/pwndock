$HOME2 = "/c/" + $HOME.Substring(3).replace("\", "/")
# echo $HOME2

docker run --rm --detach --privileged -it --net=host -v ${HOME2}:/mnt -v ${HOME2}/ctfs:/root/ctfs --hostname pwn --name pwn pwn bash 
echo "[+] Started"