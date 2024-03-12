# How to use

## Dependencies folders
> [!WARNING]
>* RRHQD
>* RRHQD-Dockers
>
> Note: The Docker compose files and the docker volumes are stored in the "RRHQD-Dockers" folder (SO DONT DELETE IT, unless you know what you are doing). The "RRHQD" folder is the main folder for the script.

> [!TIP]
>- Run the setup via the command below.
>
>- Follow the setup "guide" after.
>
>- When asked what branch do you want to use, select the branch you want to use. If you want to use a stable branch, select "Prod".
>
>- If you want to the nightly updated code base, then use the "PoC" branch.

> [!CAUTION]
>***Don't use the Dev branch***

## Setup Command

```
bash <(wget -qO- https://raw.githubusercontent.com/RunesRepoHub/RRHQD/Prod/Setup.sh)
```

## Custom Commands 
> [!NOTE]
>To use custom commands you will have to run 

> [!WARNING]
>***This is for Ubuntu, Debian, Zorin OS and Linux Mint.***

```
source ~/.bashrc
```

> [!WARNING]
>***This is for Kali Linux***

```
source ~/.zshrc
```

--------------------------------------------------------------------

> [!TIP]
>If you want to access the script again after exiting it use the command below.

```
qd
```

