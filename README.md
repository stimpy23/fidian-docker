# fidian-docker
Dockerized version of Fidian, a debian based all-in-one Fido system with binkd, husky and GoldEd+ installed.

## Tags
* latest ([Dockerfile](https://github.com/stimpy/fidian-docker/blob/master/Dockerfile))

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
    
* `TZ`
    
    Your timezone
    
    eg: Europe/Berlin
    
## Exposed ports
* `24554`

## Volumes
* `/etc/binkd`
    
    binkd configuration files
    
* `/etc/husky`
    
    husky configuration files
    
* `/var/spool/ftn`
    
    data
    
## How to use this container
```
docker run -d \
  -v /etc/binkd:/etc/binkd \
  -v /etc/husky:/etc/husky \
  -v /var/spool/ftn:/var/spool/ftn \
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
  -e TZ="Europe/Berlin" \
  -p 24554:24554 \
  --name fidian \
  stimpy/fidian-docker
```
enter as user `fido`:
```
docker exec -u fido -t -i fidian /bin/bash
```
If not configured via environment variables, fidian config wizard will start on first login as user fido.
