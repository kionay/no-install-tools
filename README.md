# No-Install-Tools

## Premise

Instead of installing python or node, why not just use docker?

Running python by itself will open up an interactive shell, and running the python docker image will open the interactive shell in the container.

```powershell
docker run -it --rm python:latest python
```

## Persistant Storage

"But", you say, "I want to include a pip-installed package in this interactive shell."

We can run pip from this same container with a similar command. Say we want to install the requests package.

```powershell
docker run -it --rm python:latest pip install requests
```

It's true that each time the container spins down you'll lose the packages in that container. Let's make a docker volume to persist storage.

```powershell
docker volume create python-global-library
```

Then mount it to `/usr/local/lib` with the newer `--mount` syntax.

```powershell
docker run -it --rm --mount source=python-global-library,target=/usr/local/lib python:latest pip install requests
```

Then the next time we run python we can use that same mount and our global packages will be there.

## Arbitrary Arguments

"But", you say, "I want to be able to run an arbitrary python command."

This is where this solution becomes _very_ windows-centric.

We can create a powershell profile, and in that powershell profile make a `python` function. That function will run the same command, but have access to `$args`.

```powershell
function python {
    docker run -it --rm --mount source=python-global-library,target=/usr/local/lib python:latest python $args
}
```

When we type in `python` to powershell we will be running this powershell function, and any arguments to the function become arguments added to the docker command.
Then for convenience we add some powershell functions for checking if a docker volume exists, and creating it if it doesn't.

```powershell
function dockerVolumeExists {
    $volume_name = $args[0]
    if(docker volume ls --format "{{.Name}}" | Where-Object {$_ -like $volume_name}) {
        $true
    } else {
        $false
    }
}
```

Then our function can use it like so.

```powershell
function python {
    if(dockerVolumeExists "python-global-library" -eq $false) {
        docker volume create python-global-library
    }
    docker run -it --rm --mount source=python-global-library,target=/usr/local/lib python:latest python $args
}
```

## Inject Current Working Directory

"But", you say, "I want to be able to run a python file in **my current directory**."

Wow you don't let up, do you?
Alright, well the working directory for python is `/` so we can't just bind mount that to the current directory.
Instead lets bind mount the current working directory to `/root` and override the `WORKDIR` of the image to be `/root`.

```powershell
docker run -it --rm 
  --mount source=python-global-library,target=/usr/local/lib # persist storage
  --mount source=${PWD},target=/root,type=bind               # bind current directory
  -w /root                                                   # override working directory
  python:latest python $args
```

## Beyond Python

"But", you complain, "I want to do this for more than just Python!"

In anticipation of doing this for other software, such as node, I have tried to separate the tools into their own directories.
To combine them all into one powershell file I have the powershell directory mounted into the dev container.
Then there is a shell script to take each program-specific file-fragment and append them all to the powershell profile.

Running `./compile_powershell_profile.sh` will do just that, and though you may end up with a large file as your powershell profile, 
at least you don't have to install each of these programs.

Using the `latest` tag in the docker commands also allows the programs to self-update.

## But Why?

"But", you persist, "why did you do all of this? Why not just install python and node?"

When I need python, node, or some other tool for a particular project that project invariably gets its own virtual environment.
I think that that is a clean and organized way to handle multiple projects, with a dev container for each.
Sometimes, though, I don't want a project just to run a quick python shell and test out some syntax or code on the fly.
I also don't want to have to keep updating python, managing `py.exe` and PATH parameters and appdata folders left over in Windows.

Using this will also break some tools that look for files to run and not just arbitrarily attempting to execute commands, as there is no `python.exe` to run.
