function dockerVolumeExists {
    $volume_name = $args[0]
    if(docker volume ls --format "{{.Name}}" | Where-Object {$_ -like $volume_name}) {
        $true
    } else {
        $false
    }
}
