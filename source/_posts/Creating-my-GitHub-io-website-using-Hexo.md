---
title: Creating my GitHub.io website using Hexo
date: 2020-05-30 17:42:31
tags: [Hexo, static-site, GitHub, Git, Resource]
categories: [Markdown, Node, Hexo]
---
## Introduction

I've been interested in creating my own blog website for a while. I regularly create documentation in markdown and wanted an easy way to create a blog using markdown. I looked at [Github pages](https://pages.github.com/), and created a very basic page using markdown. Github pages suggested using [Jekyll](https://help.github.com/en/github/working-with-github-pages/setting-up-a-github-pages-site-with-jekyll) to create a blog.
 
## Research

I googled static site generator using markdown. After researching several options including [Gatsby.js](https://www.gatsbyjs.org/) and **Jekyll**, I selected **Hexo**, as I use [Laragon](https://laragon.org/) for my development environment, I already have **Node.js** installed. I didn't want to install **Ruby** for **Jekyll** or use **React** with **Gatsby.js**. Although **Gatsby.js** does support Markdown, I just wanted a simple way to write in Markdown and generate the site.
 
## Requirements

I already had all the requirements to install **Hexo**, as they are build into **Laragon**. 

- [Node.js](https://nodejs.org/en/download/) - `Hexo` is build on `Node.js` and installed using `npm`
- [Git](https://git-scm.com/downloads) - Required to pull in Themes (more later)
- [Hexo](https://hexo.io/) - Installed using npm.

## Learning

I found the [documentation](https://hexo.io/docs/) easy to follow and understand. There is some **Yaml** config required, but found is very easy to configure. The documentation also had links to a YouTube tutorial [Hexo - Static Site Generator | Tutorial](https://www.youtube.com/playlist?list=PLLAZ4kZ9dFpOMJR6D25ishrSedvsguVSm) - by Mike Dane c Sep 2017. Which was also very helpful.
 
## Themes

There are links from the **Hexo** site to **Themes** which allow the created blogs to be tailored as required. I several  options and settled on [hexo-theme-random](https://github.com/stiekel/hexo-theme-random).

## My Setup

I had already setup my github pages site and created a **hello world** page. I cloned this to my local development machine. **c:\laragon\www\pen-y-fan.github.io**

I followed the **Hexo** tutorial and created a **hexo-pen-y-fan** project.

```shell script
hexo init hexo-pen-y-fan
cd hexo-pen-y-fan
```

I then pulled in the theme I choose.

```shell script
git clone https://github.com/stiekel/hexo-theme-random.git themes/random
```

Followed the instructions in the **README** and configured main config file **_config.yml** for the theme.

I configured the **theme/random/_config.yml** as instructed and ran the commands to generate **tags** and **categories**, modifying the **index.md** of each as required.

## Testing

It was now time to test! The created site comes with a **Hello world** blog. The website can be spun up locally using `hexo server`. This generates a local server running on post 4000 <http://localhost:4000>. Clicking the linking launches Google Chrome, and the website was brought to life.

## Deploying

The documentation for deploying [Hexo to Github pages](https://hexo.io/docs/github-pages) include signing up for **Travis CI**, I don't have an account and thought of a slightly different way to do this using windows batch script, 

```shell script
hexo generate
xcopy .\public\*.* ..\Pen-y-Fan.github.io\ /s /d /y
cd ..\Pen-y-Fan.github.io\
git status
git add .
git commit -m "Added first blog"
git push origin master
```

Explanation:

1. **Hexo** generates the static content in the **public** folder
2. **xcopy** is used to copy new files and folders, overwriting exiting files (**Note:** there is a problem that any deleted files are not deleted)
3. change directory to the new website
4. **Git** is used to check the status
5. **Git** adds all new and changed files
6. **Git** commit the added files with a description of the changes
7. If everything has gone well the new website can be pushed to GitHub

Opening <https://github.com/Pen-y-Fan/Pen-y-Fan.github.io> shows the new content has been uploaded. Opening <https://pen-y-fan.github.io/> shows new website is live! 😁

## Testing

Testing the website there are some problems:
 
- **Tags** and **Categories** are empty.
- **About** displays a 404.
- Social media links are incorrect and incomplete.

## Settings for social media

The social media links are controlled by the theme config file, open **themes/random/_config.yml**

Search for social and update to my settings:

```yaml
social:
  Twitter: https://twitter.com/MikeAPritch
  LinkedIn: https://www.linkedin.com/in/michael-pritchard-340b4520/
  R: https://www.reddit.com/user/Pen-y-Fan
  GitHub: https://github.com/pen-y-fan
```

While the file was open some other settings were tweaked:

```yaml
# html lang
language: en
# main menu navigation
menu:
  Home: index.html
  Posts: archives # was Archives: archives
  Tags: tags
  Categories: categories
  About: about
  Github: https://github.com/pen-y-fan

# Miscelaneous
favicon: /favicon.ico # new favicon.ico created using RealFaviconGenerator.net

# scripts loaded in the end of the body
scripts:
- /js/jquery-3.5.1.min.js # updated to latest version (downloaded from jQuery.com)
# .. other scripts

vegasConfig:
# ...
  timer: true
  delay: 30000 # was 150000 (150 seconds, try 30 seconds)
  shuffle: true
  count: 12
```

## Updating the website config

The root **_config.yml** was also updated:

```yaml
# Site
title: 'Pen y Fan'
subtitle: 'My coding posts'
description: 'Posts about my coding experiences, primarily for my learning path with PHP, good clean professional code.'
keywords: 'PHP, Learning, resource, HTML, CSS, Git, Github'
author: 'Pen y Fan'
language: en
timezone: 'UTC'

# URL
## If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
url: https://pen-y-fan.github.io
root: /
```

The live server looks much better now.

## Create an About Page

```shell script
hexo new about "about"
```

Edit the **source/about/index.md**

```markdown
---
title: Pen y Fan
date: 2020-05-30 16:27:25
---
I am a father, husband and geek. ....
```

The menus are now working as expected.

## Create the First Post

```shell script
hexo new "Creating my GitHub.io website using Hexo"
```

Edit the generated post
 
 - Add some Categories and Tags
 - Create some content
 
```markdown
---
title: Creating my GitHub.io website using Hexo
date: 2020-05-30 17:42:31
tags: [Hexo, static-site]
categories: 
- [Markdown, Node]
---
## Introduction

I've been interested in creating my own blog website for a while. ...
```

Checking the live website now shows content in the categories and tags menus.

## Create a README.md

As this project will be created on GitHub, I want to create a **README.md**, some boilerplate information can be copied to the README, particularly the Hexo commands. 

```markdown
# Hexo Pen y Fan

[Hexo.io](https://hexo.io/) static site generator for my static site [pen-y-fan.github.io](https://pen-y-fan.github.io/)

...
```
    
## Delete Hello World

Time to delete the **Hello World** boilerplate blog, created when the site was initiated.

Expand **source\_posts** delete **hello-world.md**

## Time to Go Live

The website can be generated and deployed again.

## Conclusion

The criteria:

- Setup a free GitHub pages site
- Allow markdown files to be used to create the blogs

Both criteria have been met. Overall I'm happy with the result, ***all*** I need to do now is add more content. I have a lot of content already written in Markdown, I need to copy it in and add **Front-matter** to the beginning of the Markdown, enter a created data, Hexo will take care of the blog.  
