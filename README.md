# Tiny Tiny RSS

Build our own ttrss docker image.

## Steps

```
cd priv/images/ttrss
git clone https://git.tt-rss.org/fox/ttrss-docker-compose.git

cd ttrss-docker-compose/app/
docker build -t ttrss .
```

## Source

* https://tt-rss.org/wiki/InstallationNotes
* https://git.tt-rss.org/fox/ttrss-docker-compose/src/branch/static-dockerhub/src/app