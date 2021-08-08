# Hexo Pen y Fan

[Hexo.io](https://hexo.io/) static site generator for my blog site
 [pen-y-fan.github.io](https://pen-y-fan.github.io/)

## Requirements

- [Node.js](https://nodejs.org/en/download/) or [Docker](https://docs.docker.com/get-docker/)
- [Hexo](https://hexo.io/) or [Docker](https://docs.docker.com/get-docker/)
- [git](https://git-scm.com/downloads)

## Installation of Hexo

- Official Documentation: [hexo.io/docs](https://hexo.io/docs/)
- YouTube: [Hexo - Static Site Generator | Tutorial](https://www.youtube.com/playlist?list=PLLAZ4kZ9dFpOMJR6D25ishrSedvsguVSm)
  by Mike Dane c Sep 2017.

## Clone repository

```shell script
git clone git@github.com:Pen-y-Fan/hexo-pen-y-fan.git
cd hexo-pen-y-fan
```

## Quick Start

### Run server

The server can be started on port 4000

```shell script
# with Make and Docker
make server
# with node/yarn installed
yarn server
# or node/npm installed
npm run server
# or, with node and hexo has been installed globally
hexo server
```

Once started open the browser <localhost:4000>

More info: [Server](https://hexo.io/docs/server.html)

### Docker information

`make server` Will start the container equivalent to:

`docker run -d -p 4000:4000 -u $(id -u):$(id -g) -v $(pwd):/app -w /app --rm node:12.18.4-alpine yarn server`

- `d` starts the docker container in a demon (background)
- `-p 4000:4000` on port 4000 and expose port 4000
- `-u $(id -u):$(id -g)` under the current user's account
- `-v $(pwd):/app` map the current directory to /app in the container
- `-w /app` make /app the working directory
- `--rm` when the container is closed it will be removed
- `-it` allow an interactive terminal
- `node:12.18.4-alpine` the node 12 LTS release
- `yarn server` run the server script `hexo server`

Note: Node 14 LTS has a [regression in Node 14](https://github.com/hexojs/hexo/issues/4257), therefore the
**composer-compose.yml** has been configured to use Node 12 until this is resolved. Node 12 is in maintenance until
30 April 2022.

### Create a new post

Options, depending on node being installed, with or without but hexo, or docker can be used, via make command.

```shell script
# or with Make and Docker:
make hexo new=My-New-Post
# Note: The `title` will need to be manually updated in the My-New-Post.md file

# or if node is installed, but hexo not:
npx hexo new "My New Post"
# or with node and hexo has been installed globally:
hexo new "My New Post"
```

More info: [Writing](https://hexo.io/docs/writing.html)

### Adding pictures

The [hexo-asset-link](https://github.com/liolok/hexo-asset-link) extension has been added, which allow pictures to be
added and previewed using hexo server. When a new post is created, a folder with the same name is also created in
source/_posts directory. Images saved in this folder can easily be added to a blog post. e.g.

```text
![Alt Text](./2019-02-14-Test-Post/Test-Image.png "Title Text")
![Docker settings](./Set-up-PhpStorm-to-use-PHP-with-PHPUnit-and-xDebug-in-Docker/docker-settings.png "Docker settings")
```

### Generate static files

Options, depending on node being installed, with or without but hexo, or docker can be used, via make command

```shell script
# with Make/Docker
make generate
# or with node/yarn installed
yarn generate
# or with node/npm:
npx hexo generate
# or if hexo has been installed globally
hexo generate
```

More info: [Generating](https://hexo.io/docs/generating.html)

## Deploy

Once the public directory has been generated, assuming `Pen-y-Fan.github.io` is existing, in the same patent directory
as `hexo-pen-y-fan`

```shell script
copy-public.cmd
# cp -r -u ./public/* ../Pen-y-Fan.github.io/
cd ../Pen-y-Fan.github.io/
git status
git add .
git commit -m "Post ... added"
git commit -m "Add post VS Code with PHP and Xdebug 3 2021"
git push
cd ../hexo-pen-y-fan
git status
git add .
git commit -m "Post ... added"
git push
```
