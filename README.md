# Tiny Tiny RSS

Build our own ttrss docker image.

## Steps

To build the image simply run:

```
docker build -t ttrss .
```

Here an example on how to run the image:

```
docker run --rm --name ttrss -p 8080:8080 --env-file docker-env ttrss
```

**Configuration**

An example env file for configuration can be found [here](env.example).

A list with available config options for ttrss can be found [here](https://git.tt-rss.org/fox/tt-rss/src/branch/master/classes/config.php).

The initial user credentials are **admin** and **password**.

## Notes

### supervisord

All services are started with supervisord. To get the logs through docker logs
the Python package supervisord-stdout is needed. Unfortunately the package in
Pypi is outdated but the latest commit in the Github repository is working.

## Sources

* https://tt-rss.org/wiki/InstallationNotes
* https://git.tt-rss.org/fox/ttrss-docker-compose
* https://github.com/HenryQW/Awesome-TTRSS
* https://github.com/clue/docker-ttrss