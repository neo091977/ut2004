## !!do not use work in progess!!!

# ut2004
A dedicated Unreal Tournament 2004 server


## Quickstart

This sample starts a CTF match and enables the web interface at http://localhost/ with admin password password1234

```
docker pull neo091977/ut2004

docker run -d \
    --name ut2004 \
    -p 8080:8080 \
    -p 7777:7777/udp \
    -p 7778:7778/udp \
    -e "CONFIG_1=[Engine.AccessControl];AdminPassword=password123;[UWeb.WebServer];bEnabled=True" \
    -e "UT2004_CMD=CTF-FACECLASSIC?game=XGame.xCTFGame" \
    neo091977/ut2004
```

## Features

* Full-patched 64-bit dedicated server
* Support for downloading and installing addons (maps, mutators, etc)
* Support for configuring advanced ini settings
* Support for compressing addons for serving via nginx, apache, etc
* Support for web interface
