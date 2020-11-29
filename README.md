# squeezelite

A Squeezelite docker

```
$ docker pull jpmenil/squeezelite
$ docker run --rm -detached --cap-drop ALL --read-only --name squeezelite --device=/dev/snd/ -v /etc/localtime:/etc/localtime:ro squeezelite:latest -M Hifiberry -m "de:ad:be:ef:00:01" -n Room -o "default:CARD=sndrpihifiberry" -s "ip:port" -d all=info
```

(need chmod -R a+rw /dev/snd/)
or start your container, mapping your local audio group:
```
-u nobody:$(getent group audio | awk -F: '{print $3}')
```
