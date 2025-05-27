# Kali Linux Container Environment

## Feature

- enable ssh connect (port:2222)
- enable xrdp connect (port:53389)
- install kali-linux-everything

## Setup

1. define username (ie: bob)
2. clone repo

```zsh
git clone git@github.com:niraiarin/kali-portable-container.git
cd kali-portable-container
```

3. edit 'authorized_keys' file (insert ssh pub key strings)

```zsh
touch authorized_keys
vim authorized_keys
```

4. make working directory

```zsh
mkdir workdir
```

## Build

```zsh
## default arg:user is alice
docker compose build --build-arg user=bob
```

## Start

```zsh
docker-compose up -d
```

## Connect

### SSH

example of ~/.ssh/config:

```config
Host local.docker.kali
  HostName localhost
  Port 2222
  User bob
  IdentityFile ~/.ssh/id_e25519
```

```zsh
ssh local.docker.kali
```

### XRDP

Use [remmina](https://remmina.org/) or Windows Remote Desktop to connect ``localhost:53389``
