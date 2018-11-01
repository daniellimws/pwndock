if ( $args.count -ge 1 ) {
    docker exec -it pwn $args
}
else {
    clear
    docker exec -it pwn zsh
}
