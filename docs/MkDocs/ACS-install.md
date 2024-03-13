# ACSF Installation

***Automated Content System Full***

## Important Information

!!! failure "Root User Required"

    ### Root User Required

    This software will only run as root. ***YOU CAN NOT RUN IT AS A NORMAL USER***.

??? bug "Important"

    ### Important

    This software is still in development.

    Please report bugs to [Github](https://github.com/RunesRepoHub/ACS/issues)

??? danger "Docker is required"

    ### Docker is required

    Docker is required to run this software

    [Get Docker on Debian 12](https://linuxiac.com/how-to-install-docker-on-debian-12-bookworm/)

    [Get Docker on Debian 11](https://docs.docker.com/engine/install/debian/)

    [Get Docker on Ubuntu 20.04](https://docs.docker.com/engine/install/ubuntu/)


## Install command

??? danger "Performence"

    ### Youtube-dl Performence

    The Youtube-dl has some issues when it comes to downloading.
    Mainly because of long playlists and/or multiple downloads running at ones.

    This will result in these errors. (And possible more)

    * Can cause a softlog error on proxmox when running it in an VM.

    * The longer the playlists the longer the download. (At download item 86 of 156 it takes 30 mins of 400mb of data, THIS is NOT a networking limit)

    * Can cause a bit of slow down on plex itself if configured to update library on every change dectected in the folder.


!!! success "Install ACSF"

    ### Install ACSF

    [See the requirements](https://runesrepohub.github.io/ACS/requirement.html)

    Use this command

    ```
    bash <(wget -qO- https://raw.githubusercontent.com/RunesRepoHub/ACS/Production/setup.sh)
    ```
    
    After the install has finished you can use these commands for quick access and control

## Jackett Indexers Script

??? tip "From the Jackett page, click the "add indexer" button so that the pop up window with the full list of indexers appears."

    ### Setup jackett indexers

    * Go to your http://your-server-ip:9117
    * Click on add indexer

    ![Alt text](img/jackett2.png)

    * You'll then need to open your browser's development toolbar (in Chrome just hit F12) 
    * Go to the JavaScript Console and enter the following:
    * And click "CTRL+Enter" to run the JavaScript

    ```
    ////hack to add all free indexers in Jackett
    $(document).ready(function () {
        EnableAllUnconfiguredIndexersList();
    });


    function EnableAllUnconfiguredIndexersList() {
        var UnconfiguredIndexersDialog = $($("#select-indexer").html());

        var indexersTemplate = Handlebars.compile($("#unconfigured-indexer-table").html());
        var indexersTable = $(indexersTemplate({ indexers: unconfiguredIndexers, total_unconfigured_indexers: unconfiguredIndexers.length  }));
        indexersTable.find('.indexer-setup').each(function (i, btn) {
            var indexer = unconfiguredIndexers[i];
            $(btn).click(function () {
                $('#select-indexer-modal').modal('hide').on('hidden.bs.modal', function (e) {
                    displayIndexerSetup(indexer.id, indexer.name, indexer.caps, indexer.link, indexer.alternativesitelinks, indexer.description);
                });
            });
        });
        indexersTable.find('.indexer-add').each(function (i, btn) {
        
                $('#select-indexer-modal').modal('hide').on('hidden.bs.modal', function (e) {
                    var indexerId = $(btn).attr("data-id");
                    api.getIndexerConfig(indexerId, function (data) {
                        if (data.result !== undefined && data.result == "error") {
                            doNotify("Error: " + data.error, "danger", "glyphicon glyphicon-alert");
                            return;
                        }
                        api.updateIndexerConfig(indexerId, data, function (data) {
                            if (data == undefined) {
                                reloadIndexers();
                                doNotify("Successfully configured " + name, "success", "glyphicon glyphicon-ok");
                            } else if (data.result == "error") {
                                if (data.config) {
                                    populateConfigItems(configForm, data.config);
                                }
                                doNotify("Configuration failed: " + data.error, "danger", "glyphicon glyphicon-alert");
                            }
                        }).fail(function (data) {
                            if(data.responseJSON.error !== undefined) {
                    doNotify("An error occured while configuring this indexer<br /><b>" + data.responseJSON.error + "</b><br /><i><a href=\"https://github.com/Jackett/Jackett/issues/new?title=[" + indexerId + "] " + data.responseJSON.error + " (Config)\" target=\"_blank\">Click here to open an issue on GitHub for this indexer.</a><i>", "danger", "glyphicon glyphicon-alert", false);
                } else {
                    doNotify("An error occured while configuring this indexer, is Jackett server running ?", "danger", "glyphicon glyphicon-alert");
                }
                            
                        });
                    });
                });
            
        });
        indexersTable.find("table").DataTable(
            {
                "stateSave": true,
                "fnStateSaveParams": function (oSettings, sValue) {
                    sValue.search.search = ""; // don't save the search filter content
                    return sValue;
                },
                "bAutoWidth": false,
                "pageLength": -1,
                "lengthMenu": [[10, 20, 50, 100, 250, 500, -1], [10, 20, 50, 100, 250, 500, "All"]],
                "order": [[0, "asc"]],
                "columnDefs": [
                    {
                        "name": "name",
                        "targets": 0,
                        "visible": true,
                        "searchable": true,
                        "orderable": true
                    },
                    {
                        "name": "description",
                        "targets": 1,
                        "visible": true,
                        "searchable": true,
                        "orderable": true
                    },
                    {
                        "name": "type",
                        "targets": 2,
                        "visible": true,
                        "searchable": true,
                        "orderable": true
                    },
                    {
                        "name": "type_string",
                        "targets": 3,
                        "visible": false,
                        "searchable": true,
                        "orderable": true,
                    },
                    {
                        "name": "language",
                        "targets": 4,
                        "visible": true,
                        "searchable": true,
                        "orderable": true
                    },
                    {
                        "name": "buttons",
                        "targets": 5,
                        "visible": true,
                        "searchable" : false,
                        "orderable": false
                    }
                ]
            });

        var undefindexers = UnconfiguredIndexersDialog.find('#unconfigured-indexers');
        undefindexers.append(indexersTable);

        UnconfiguredIndexersDialog.on('shown.bs.modal', function() {
            $(this).find('div.dataTables_filter input').focusWithoutScrolling();
        });

        UnconfiguredIndexersDialog.on('hidden.bs.modal', function (e) {
            $('#indexers div.dataTables_filter input').focusWithoutScrolling();
        });

        $("#modals").append(UnconfiguredIndexersDialog);

        UnconfiguredIndexersDialog.modal("show");
    }
    ```

## Configure Deluge 

??? example "Deluge"

    ### Setting up deluge

    * Go to your http://your-server-ip:8112
    * Go to preferences 
    * Downloads tab
    * Set download to /downloads
    * Set download completed to /downloads/completed
    
    ![Alt text](img/deluge.png)

    * Go to plugins
    * Enable Label
    * Press apply

    ![Alt text](img/deluge2.png)

## Configure Sonarr and Radarr

??? example "Indexers"

    ### Setting up indexers on sonarr and radarr

    **Port 8989 for sonarr**
    
    **Port 7878 for radarr**

    * Go to your http://your-server-ip:8989
    * Go to settings 
    * Indexers

    ![Alt text](img/image.png)
    ![Alt text](img/radarr2.png)

    **All indexers is just another name of jackett**

    ![Alt text](img/jackett.png)

    *Access your jackett docker container and find your own information*

    * Go to your http://your-server-ip:9117
    * Get the api key 
    * Then copy the "Torznab Feed" from the torrent indexer you want to use.
    
    **Follow the steps below**

    * Then click the plus to add a new one
    * Fill in the name of the indexer
    * Fill in the url of the indexer
    * Fill in the api key of the indexer

    ![Alt text](img/image-1.png)
    ![Alt text](img/radarr3.png)

    *I recommend that you use advanced settings while setting up the indexers.*

    * Because all the yellow fields are "advanced settings"
    * And one of them allow your to setup minimal amount of seeds before downloading
    
    **I used 10 seeds for sonarr and 15 seeds for radarr**

??? example "Download Client"

    ### Adding the deluge download client.

    * Then click the plus to add a new one
    
    ![Alt text](img/image-2.png)
    ![Alt text](img/radarr7.png)

    * Fill in the name of the client (Deluge)
    * Fill in the ip of the client
    * Fill in the port of the client (Default: 8112)
    * Fill in the password of the client (Deluge)

    ![Alt text](img/image-3.png)
    ![Alt text](img/radarr4.png)

    **This might be need on radarr**

    ![Alt text](img/radarr5.png)

??? example "Episode Naming"

    ### Episode Naming

    Enable renaming of the episode.

    * Then click the add root folder button
    * Find the respective folder and click on it (Sonarr = shows, Radarr = movies)

    ![Alt text](img/image-4.png)
    ![Alt text](img/radarr.png)

    * You can change the name convention of the episode here (Optional)

??? example "Download profile"

    ### Download profile
    
    I like to make my own download profiles.

    * Remove all default
    * Add a standard profile for 720p
    * Add a standard profile for 1080p

    **I have added both to one to show which I would "mark"**
    
    **You should make one for each**

    ![Alt text](img/image-5.png)
    ![Alt text](img/radarr6.png)

## Configure Ombi

??? example "Ombi setup"

    ### Ombi setup

    #### Load Plex Server

    * Go to settings 
    * Media Server
    * Login into plex
    * Load your servers
    * And then submit/save

    ![Alt text](img/ombi.png)

    #### Load Radarr Server

    * Go to the http://your-server-ip:3579
    * Go to settings 
    * Movies
    * Enable it at the top 
    * Enable "Scan for Availability"
    * Enable "Add the user as a tag"
    * Add the ip of the server
    * Add the port of the server. (default: 7878)
    * Load and set quality profiles
    * Load and set the default root folder
    * Load language profiles
    * Load Default minimum availability (Physical/Web)

    #### Get your Radarr api key
    
    * Go to settings
    * General
    * Under security
    * Find your api key 

    **Then Save/Submit**

    ![Alt text](img/radarr-api.png)

    ![Alt text](img/ombi2.png)

    #### Load Sonarr Server

    * Go to the http://your-server-ip:3579
    * Go to settings 
    * TV
    * Enable it at the top 
    * Enable "Scan for Availability"
    * Enable "Add the user as a tag"
    * Add the ip of the server
    * Add the port of the server. (default: 8989)
    * Load and set quality profiles
    * Load and set the default root folder
    * Load language profiles

    #### Get your Sonarr api key
    
    * Go to settings
    * General
    * Under security
    * Find your api key
    
    **Then Save/Submit**

    ![Alt text](img/sonarr-api.png)

    ![Alt text](img/ombi3.png)

## Configure Tautulli 

??? example "Tautulli setup"

    ### Tautulli setup

    * Go to the http://your-server-ip:8181
    ![Alt text](img/tautulli.png)
    * Click on "Next"
    * Sign in with plex
    ![Alt text](img/tautulli2.png)
    ![Alt text](img/tautulli3.png)
    ![Alt text](img/tautulli4.png)
    * Click on "Next"
    * Pick the plex server you want to use
    * Input the plex port
    ![Alt text](img/tautulli5.png)
    * Click on "Next"
    * **Activity Logging**
    ![Alt text](img/tautulli6.png)
    * Just set the "ignore interval" to 120
    * Click on "Next"
    * **Notifications**
    ![Alt text](img/tautulli7.png)
    * Click on "Next"
    * **Database import**
    ![Alt text](img/tautulli8.png)
    * Click on "Finish"
    ![Alt text](img/tautulli9.png)
    ![Alt text](img/tautulli10.png)