# Hexo Pen y Fan

[Hexo.io](https://hexo.io/) static site generator for my static site
 [pen-y-fan.github.io](https://pen-y-fan.github.io/)

## Requirements

- [Node.js](https://nodejs.org/en/download/)
- [Hexo](https://hexo.io/)
- [git](https://git-scm.com/downloads)

## Installation of Hexo

- Official Documentation: [hexo.io/docs](https://hexo.io/docs/)
- YouTube: [Hexo - Static Site Generator | Tutorial](https://www.youtube.com/playlist?list=PLLAZ4kZ9dFpOMJR6D25ishrSedvsguVSm) -
 by Mike Dane c Sep 2017.

### TL&DR install

Install Hexo globally:

```shell script
npm install -g hexo-cli
``` 

## Clone repository

```shell script
get clone git@github.com:Pen-y-Fan/hexo-pen-y-fan.git
cd hexo-pen-y-fan
``` 

## Quick Start

### Create a new post

```shell script
hexo new "My New Post"
```

More info: [Writing](https://hexo.io/docs/writing.html)

### Run server

```shell script
hexo server
```

More info: [Server](https://hexo.io/docs/server.html)

### Create tags list page and categories list page

Hexo does NOT create tags list page and categories list page in default, but Random theme provide those pages, you just
 need to create it.

If you want to create tags list page, run this command in blog root path:

```sh
hexo new page tags
```

This will create the `tags` folder, and a markdown file `source/tags/index.md`, change the `type` value of this file as
 following:

```yml
title: Tags
date: 2016-01-16 06:17:29
type: "tags"
comments: false
```

The same to create categories list page:

```sh
hexo new page categories
```

Modify the `source/categories/index.md` as following:

```md
title: Categories
date: 2015-08-03 14:19:29
type: "categories"
comments: false
```

### Generate static files

```shell script
hexo generate
```

More info: [Generating](https://hexo.io/docs/generating.html)

## Deploy

Assuming `Pen-y-Fan.github.io` is existing in the same patent directory as `hexo-pen-y-fan`

```shell script
copy-public.cmd
cd ..\Pen-y-Fan.github.io\
git status
git add .
git commit -m "Site updated..."
git push origin master
```

