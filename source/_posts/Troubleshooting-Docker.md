---
title: Troubleshooting Docker
date: 2021-02-12 20:33:57
tags: [Docker, Tutorial, Linux]
categories: [Docker]
---

I have been using Docker since I installed [Pop!_OS On my laptop Oct 2020](./Pop-OS-new-install.md). I deliberately have not installed PHP, MySQL or Apache on my laptop, which has forced me to learn to use Docker!

The first tutorial I followed was the Docker docs [get started](https://docs.docker.com/get-started/) after I installed Docker. I found this to be a useful introduction, even though I wanted a PHP environment, the guide still explained the basics of Docker. I will not cover the basics here, as these are already well covered in the getting started documentation, there are many youtube channels, some I have watched are:

- [Learn Docker in 12 Minutes 🐳](https://www.youtube.com/watch?v=YFl2mCHdv24) by Jake Wright 
- [Docker Tutorial for Beginners - A Full DevOps Course on How to Run Applications in Containers](https://www.youtube.com/watch?v=fqMOX6JJhGo) by freeCodeCamp.org
- [Exploring Docker \[1\] - Getting Started](https://www.youtube.com/watch?v=Kyx2PsuwomE) and 
- [Exploring Docker \[2\] - Docker Compose With Node &amp; MongoDB](https://www.youtube.com/watch?v=hP77Rua1E0c) by Traversy Media.

Brad Travery has also published an excellent gist:

- [Docker Commands, Help & Tips](https://gist.github.com/bradtraversy/89fad226dc058a41b596d586022a9bd3) with all the basic commands!

## So what is the blog about?

What I want to cover are the parts beyond the basics. 

- file permissions is one of my biggest problems
- creating a development environment, with the tooling I want at my fingertips.

## File permissions

One of the first hurdles I came across was to do with file permissions. This seams to be particularly on Linux. When the container is launched, the default user is root, if any files are changed, the file system on the OS will be assigned to root!

For example, if we pull down a repository and want to spin up a docker container for composer `docker run composer install`, however the vendor folder will be created as root, along with all the files and subfolders.

The initial workaround is to run `chown` from the host machine, e.g.

```sh
sudo chown -R michael:michael ./vendor
# or
sudo chown -R $(id -u):$(id -g) ./vendor
```

`$(id -u):$(id -g)` is a way of getting the username and group of signed-in user. e.g.

```shell
whoami
# michael
id -u
# 1000
id -g
# 1000
id $(whoami)
# uid=1000(michael) gid=1000(michael) groups=1000(michael),...
```

Examples of options are uid:gid, this is normally 1000:1000 or user:group in my case michael:michael, further reading [Find a user's UID or GID in Unix](https://kb.iu.edu/d/adwf). Further details on [Running Docker Containers as Current Host User](https://jtreminio.com/blog/running-docker-containers-as-current-host-user/).

## Composer Docker Image

Composer is the dependency manager for PHP.

- [Docker hub composer images](https://hub.docker.com/_/composer)

### Basic usage

The documentation has the following basic usage:

```shell script
docker run --rm --interactive --tty \
  --volume $PWD:/app \
  composer install
```

The same command, can be converted to the shorter syntax. By making it into one line, copying and pasting is easier.

```shell
docker run --rm -it -v $PWD:/app composer install
```

Explanation for the command line:

- `docker run` runs a new instance of a docker image creating a container
- [Clean up (--rm)](https://docs.docker.com/engine/reference/run/#clean-up---rm) automatically clean up the container
  and remove the file system when the container exits, **Note** the **double** minus in `--rm`!
- [--interactive --tty / -i -t / -it](https://docs.docker.com/engine/reference/run/#foreground) For interactive
  processes (like a shell), you must use -i -t together in order to allocate a tty for the container process. -i -t is
  often written -it
- [--volume / -v $PWD:/app](https://docs.docker.com/engine/reference/run/#volume-shared-filesystems) Bind the host file
  system to the destination, $PWD is the current working directory, /app is the destination directory. On Windows it
  should be the full path name e.g. c:/laragon/www/php-project
- `composer` the image to be run
- `install` is the command to run inside the docker container. This can be any composer command!

For more details please see the [Docker run reference](https://docs.docker.com/engine/reference/run/).

### Fixing filesystem permissions

By default, Composer runs as root inside the container. This can lead to permission issues on your host filesystem. You can work around this by running the container under the signed-in user:

```shell script
docker run --rm --interactive --tty \
  --volume $PWD:/app \
  --user $(id -u):$(id -g) \
  composer install
```

Again the short, but slightly less readably syntax, can be used to make one line version, with some example commands:

```shell
docker run --rm -it -v $PWD:/app -u $(id -u):$(id -g) composer install
docker run --rm -it -v $PWD:/app -u $(id -u):$(id -g) composer update
docker run --rm -v $PWD:/app -u $(id -u):$(id -g) composer test
docker run --rm -v $PWD:/app -u $(id -u):$(id -g) composer check-cs
docker run --rm -v $PWD:/app -u $(id -u):$(id -g) composer phpstan
```

You may notice, install and update have an interactive terminal -it. The test, check-cs and phpstan do not. Sometimes Composer asks questions, which need user input, to run tests and lint code this is not required.

The composer config file **composer.json** would contain the scripts for **test**, **check-cs** and **phpstan** e.g.:

**composer.json**

```json
{
//  other json
  "scripts": {
    "test": "phpunit",
    "check-cs": "ecs check --ansi",
    "phpstan": "phpstan analyse --ansi"
  }
}
```

The command is the similar, as explained above, with -u or --user added:

- [--user or -u](https://docs.docker.com/engine/reference/run/#user) Sets the username or UID used and optionally the groupname or GID for the specified command
- `$(id -u):$(id -g)` is a way of getting the username and group of signed-in user. e.g.

This is required on Linux. The OS and docker container share the same file system. The docker container will normally run under user 0, root user, meaning any files written to the shared volume by the container, will be created by the root user.

### Install composer programmatically

Sometimes Composer will not run the **install** command:

- Composer doesn't have the correct dependencies 
- Composer isn't the correct version of PHP.

For example, if I try to install Silverstripe, which needs the PHP **intl** extension:

```sh
git clone git@github.com:Pen-y-Fan/silverstripe-lessons.git
cd silverstripe-lessons
docker run --rm -it -v $PWD:/app -u $(id -u):$(id -g) composer install
```

```text
Your requirements could not be resolved to an installable set of packages.

  Problem 1
    - Installation request for silverstripe/framework 4.5.2 -> satisfiable by silverstripe/framework[4.5.2].
    - silverstripe/framework 4.5.2 requires ext-intl * -> the requested PHP extension intl is missing from your system.
  Problem 2
    - silverstripe/framework 4.5.2 requires ext-intl * -> the requested PHP extension intl is missing from your system.
    - silverstripe/versioned-admin 1.3.1 requires silverstripe/framework ^4.5 -> satisfiable by silverstripe/framework[4.5.2].
    - Installation request for silverstripe/versioned-admin 1.3.1 -> satisfiable by silverstripe/versioned-admin[1.3.1].

  To enable extensions, verify that they are enabled in your .ini files:
    - /usr/local/etc/php/php-cli.ini
    - /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini
    - /usr/local/etc/php/conf.d/docker-php-ext-zip.ini
  You can also run `php --ini` inside terminal to see which files are used by PHP in CLI mode.
```

Liekwise as more project become php8 only, for example:

```sh
git clone git@github.com:Pen-y-Fan/hello-world-php8.git
cd hello-world-php8
docker run --rm -it -v $PWD:/app -u $(id -u):$(id -g) composer install
```

```text
Fatal error: Uncaught ParseError: syntax error, unexpected ':', expecting ')' in /app/tests/HelloWorldTest.php:14

Or

Fatal error: Composer detected issues in your platform: Your Composer dependencies require a PHP version ">= 8.0.0". You are running 7.4.14. in /app/vendor/composer/platform_check.php on line 24
```

### Possible workarounds

One workaround is to spin-up the version of PHP required, with the extensions and programmatically add Composer.

```shell
#!/bin/sh
DOCKER_HOME=~/tmp
EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet --install-dir=/usr/local/bin/ --filename=composer
RESULT=$?
rm composer-setup.php
# smoke test
composer --version
exit $RESULT
```

- Source: [How do I install Composer programmatically?](https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md)

### Troubleshooting Composer

The Composer docker documentation also has the following suggestions:

- **optimal** create your own build image and install Composer inside it.

**Note:** Docker 17.05 introduced multi-stage builds, simplifying this enormously:

```dockerfile
COPY --from=composer /usr/bin/composer /usr/bin/composer
```

- **alternatively** specify the target platform / extension(s) in your composer.json:

```json
{
  "config": {
    "platform": {
      "php": "MAJOR.MINOR.PATCH",
      "ext-something": "MAJOR.MINOR.PATCH"
    }
  }
}
```

- **discouraged** pass the --ignore-platform-reqs and / or --no-scripts flags to install or update:

```sh
docker run --rm --interactive --tty \
--volume $PWD:/app \
composer install --ignore-platform-reqs --no-scripts
```

## Example Dockerfile

The docker image for Silverstripe has extensions like **tidy** and **intl** enabled. The Composer image doesn't! This
Dockerfile will copy Composer into the Silverstrip image.

**Dockerfile**

```shell
FROM brettt89/silverstripe-web:7.4-apache
COPY --from=composer /usr/bin/composer /usr/bin/composer
```

The **docker-compose.yml** file would something like:

```yaml
version: "3.3"
services:
  silverstripe:
    dockerfile: Dockerfile
    # image: brettt89/silverstripe-web:7.4-apache
    ports:
      - "8081:80"
    volumes:
      - .:/var/www/html
    depends_on:
      - database
    environment:
      - DOCUMENT_ROOT=/var/www/html/public
      - SS_TRUSTED_PROXY_IPS=*
      - SS_ENVIRONMENT_TYPE=dev
      - SS_DATABASE_SERVER=database
      - SS_DATABASE_NAME=SS_mysite
      - SS_DATABASE_USERNAME=root
      - SS_DATABASE_PASSWORD=
      - SS_DEFAULT_ADMIN_USERNAME=admin
      - SS_DEFAULT_ADMIN_PASSWORD=password

  database:
    image: mysql:5.7
    ports:
      - "33060:3306"
    environment:
      - MYSQL_ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - db-data:/var/lib/mysql
volumes:
  db-data:
```

Once the `docker-compose up -d` is run, to spin up the containers. The **silverstripe** container will have Composer
installed. This can be accessed from the terminal within the running container:

```sh
docker-compose exec -u $(id -u):$(id -g) silverstripe composer install 
```

## How to create a project from within a Docker container

Sometimes new projects need to be created from the command line, before **docker-compose.yml** can be created, in the project root.

```shell
# Navigate to your normal project root e.g.:
cd ~/PhpstormProjects/
# Spin-up a docker container which has the required extensions installed:
docker run --rm -u $(id -u):$(id -g) -v $(pwd):/app -w /app -it brettt89/silverstripe-web:7.4-apache /bin/bash
# from within the docker container, the composer.phar, which has already been downloaded is now available.
# normally this would be: composer create-project silverstripe/installer ./silverstripe-demo
# composer.phar needs to be called by php:
php composer.phar create-project silverstripe/installer ./silverstripe-demo
exit
# back at the host's command line:
cd silverstripe-demo
```

Create a `dcocker-composer.yml` and copy in this file

