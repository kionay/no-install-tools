function node {
    if(dockerVolumeExists "node-global-modules" -eq $false) {
        docker volume create node-global-modules
    }
    docker run -it --rm --mount source=node-global-modules,target=/usr/local/lib/node_modules --mount source=${PWD},target=/root,type=bind -w /root node:latest node $args
}

function npm {
    if(dockerVolumeExists "node-global-modules" -eq $false) {
        docker volume create node-global-modules
    }
    docker run -it --rm --mount source=node-global-modules,target=/usr/local/lib/node_modules --mount source=${PWD},target=/root,type=bind -w /root node:latest npm -g $args
}