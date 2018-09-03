if ( $args.count -ge 1 ) {
    docker exec -it pwn $args
}
else {
    docker exec -it pwn tmux
}
