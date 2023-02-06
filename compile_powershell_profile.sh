#!/bin/bash
powershell_profile_directory="/host-powershell"
powershell_profile_filename="Profile.ps1"

powershell_profile_file="$powershell_profile_directory/$powershell_profile_filename"

# delete it if it already exists
if [ -f "$powershell_profile_file" ]; then
    echo "$powershell_profile_file exists."
    rm $powershell_profile_file
else
    echo "$powershell_profile_file does not exist."
fi

touch $powershell_profile_file
for program in /workspaces/*/programs/* ; do
    program_name=$(basename $program)
    echo "adding $program_name to powershell profile"
    cat $program/PowershellProfileAddition.ps1 >> $powershell_profile_file
    echo -en '\n\n' >>  $powershell_profile_file
done