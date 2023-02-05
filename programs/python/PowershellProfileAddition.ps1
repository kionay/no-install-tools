function pythonGlobalExists {
    if(docker volume ls --format "{{.Name}}" | Where-Object {$_ -like "python-global-library"}) {
        $true
    } else {
        $false
    }
}

function python {
    if(!pythonGlobalExists) {
        docker volume create python-global-library
    }
    docker run -it --rm --mount source=python-global-library,target=/usr/local/lib python:latest python $args
}

function pip {
    if(!pythonGlobalExists) {
        docker volume create python-global-library
    }
    docker run -it --rm --mount source=python-global-library,target=/usr/local/lib python:latest pip $args
}