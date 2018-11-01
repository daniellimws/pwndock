$HOME2 = "/c/" + $HOME.Substring(3).replace("\", "/")

set-variable -name DISPLAY -value 192.168.56.1:0.0
docker run --rm --detach --privileged -it --net=host -v ${HOME2}:/mnt -v ${HOME2}/ctfs:/root/ctfs --hostname pwn --name pwn -e DISPLAY=$DISPLAY pwn bash 
echo "[+] Started"
