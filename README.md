# fidian-docker
Dockerized version of [Fidian](https://kuehlbox.wtf/fidian), a debian based all-in-one Fido system with [BinkD](https://2f.ru/binkd), [Husky](http://husky.sourceforge.net) and [GoldED+](https://github.com/golded-plus/golded-plus) installed and a [web console](https://github.com/tsl0922/ttyd) for easy access.

## Tags
* latest ([Dockerfile](https://github.com/stimpy/fidian-docker))
* dev ([Dockerfile](https://gitlab.ambhost.net/stimpy/docker_fidian))

## Environment Variables
* `LINK_NAME`

    Free text identifier for this link.
    
    eg: FidoNet

* `LINK_DOMAIN`

    Domain identifier (used internally to distinguish different links)
    While this is technically free text, but you should still use the standards provided by your uplink.
    
    eg: fidonet

* `YOUR_NAME`

    Your full first- and last name.
    
    eg: John Doe

* `YOUR_AKA`

    Your AKA, assigned by your uplink.
    
    eg: 2:240/5853.5

* `YOUR_SYSTEM`

    Free text to identify your system. Commonly used for the name of your BBS or just your name.
    
    eg: Johnny's Fido System

* `YOUR_LOCATION`

    Free text to identify your location.
    You're kindly asked to use a format like this: City, country.
    
    eg: Frankfurt, germany

* `YOUR_HOSTNAME`

    If your system is reachable from the internet, please enter your FQDN here.
    If it isn't, please enter your hostname here (what you get, when running "hostname")
    
    eg: your.domain.com

* `UPLINK_HOST`

    The FQDN or IP of your uplink.
    
    eg: his.domain.com

* `UPLINK_PORT`

    Port number of uplink's binkd. (Leave empty for default)
    
    eg: 24554

* `UPLINK_AKA`

    The AKA of your uplink.
    
    eg: 2:240/5853

* `SESSION_PASSWORD`

    The session- / binkp password provided by your uplink.
    
    eg: SECRET123

* `PACKET_PASSWORD`

    The packet password password provided by your uplink. (Leave empty to use SESSION_PASSWORD)
    
    eg: SECRET123

* `AREAFIX_PASSWORD`

    The areafix password provided by your uplink. (Leave empty to use PACKET_PASSWORD)
    
    eg: SECRET123

* `FILEFIX_PASSWORD`

    The filefix password provided by your uplink. (Leave empty to use AREAFIX_PASSWORD)
    
    eg: SECRET123

* `WEB_PASSWORD`
    
    The password for the web interface. (Leave empty to use "fidian")
    
    eg: fidian

* `TZ`
    
    Your timezone
    
    eg: Europe/Berlin
    
## Exposed ports
* `24554` (binkp)
* `24580` (http)

## Volumes
* `/etc/binkd`
    
    binkd configuration files

* `/etc/husky`
    
    husky configuration files

* `/var/spool/ftn`
    
    data

* `/var/log/fidian`
    
    logfiles

## Configuration
```
docker run -d \
  -v /etc/binkd:/etc/binkd \
  -v /etc/husky:/etc/husky \
  -v /var/spool/ftn:/var/spool/ftn \
  -v /var/log/fidian:/var/log/fidian \
  -e LINK_NAME="FidoNet" \
  -e LINK_DOMAIN="fidonet" \
  -e YOUR_NAME="John Doe" \
  -e YOUR_AKA="0:0/0.0" \
  -e YOUR_SYSTEM="Fidian" \
  -e YOUR_LOCATION="Trancentral" \
  -e YOUR_HOSTNAME="fidian" \
  -e UPLINK_HOST="example.com" \
  -e UPLINK_PORT="24554" \
  -e UPLINK_AKA="0:0/0" \
  -e SESSION_PASSWORD="SECRET123" \
  -e PACKET_PASSWORD="SECRET123" \
  -e AREAFIX_PASSWORD="SECRET123" \
  -e FILEFIX_PASSWORD="SECRET123" \
  -e WEB_PASSWORD="SECRET123" \
  -e TZ="Europe/Berlin" \
  -p 24554:24554 \
  -p 24580:24580 \
  --name fidian \
  stimpy23/fidian:latest
```
If not configured via environment variables, fidian config wizard will start on first login as user fido or via the web console.

## Use via console
enter as user `fido`:
```
docker exec -u fido -t -i fidian /bin/bash
```

## Use via web browser
Point your web browser to the exposed port 24580. Login with user "fido" and your WEB_PASSWORD (default: fidian)
eg: `http://localhost:24580`

**This is intended for local use only!**
You really should not make this publicly available via the internet! At least put a proxy with encryption and some real authorization in front of it.

## Third Party Software
This docker image uses a lot of different software:

* [Debian GNU/Linux](https://debian.org)
* [Docker](https://docker.io)
* [BinkD](https://2f.ru/binkd)
* [Husky](http://husky.sourceforge.net)
* [GoldED+](https://github.com/golded-plus/golded-plus)
* [Fidian](https://kuehlbox.wtf/fidian)
* [TTYd](https://github.com/tsl0922/ttyd)
