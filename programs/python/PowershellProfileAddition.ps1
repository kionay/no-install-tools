function python {
    if(dockerVolumeExists "python-global-library" -eq $false) {
        docker volume create python-global-library
    }
    docker run -it --rm --mount source=python-global-library,target=/usr/local/lib python:latest python $args
}

function pip {
    if(dockerVolumeExists "python-global-library" -eq $false) {
        docker volume create python-global-library
    }
    docker run -it --rm --mount source=python-global-library,target=/usr/local/lib python:latest pip $args
}