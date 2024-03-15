# Error Codes

## Youtube-dl Performence
!!! danger "Performence"

    The Youtube-dl has some issues when it comes to downloading.
    Mainly because of long playlists and/or multiple downloads running at ones.

    This will result in these errors. (And possible more)

    * Can cause a softlog error on proxmox when running it in an VM.

    * The longer the playlists the longer the download. (At download item 86 of 156 it takes 30 mins of 400mb of data, THIS is NOT a networking limit)

    * Can cause a bit of slow down on plex itself if configured to update library on every change dectected in the folder.

!!! failure "Error Codes"

    This is still under development.