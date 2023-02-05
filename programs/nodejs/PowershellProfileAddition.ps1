function nodeGlobalModulesExists {
    if(docker volume ls --format "{{.Name}}" | Where-Object {$_ -like "node-global-modules"}) {
        $true
    } else {
        $false
    }
}

function node {
    if(!nodeGlobalModulesExists) {
        docker volume create node-global-modules
    }
    docker run -it --rm --mount source=node-global-modules,target=/usr/local/lib/node_modules node:19-alpine node $args
}

function npm {
    if(!nodeGlobalModulesExists) {
        docker volume create node-global-modules
    }
    docker run -it --rm --mount source=node-global-modules,target=/usr/local/lib/node_modules node:19-alpine npm -g $args
}