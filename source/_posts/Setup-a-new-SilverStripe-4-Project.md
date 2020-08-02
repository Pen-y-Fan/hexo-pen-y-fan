---
title: Setup a new SilverStripe 4 Project
date: 2020-08-02 12:59:16
tags: [CMS, Tutorial, PHP]
categories: [Silverstripe]
---
I have recently started a new job as a software developer, the tech stack includes a content management system (CMS) called Silverstripe. I therefore wanted to learn the Silverstripe CMS. The inital process of creating a project should be straight forward, there are supposed to be beginner lessons.

The first three lessons on how to set up a silverstripe project are confusing, as there is intermixed talk about upgrading from silverstripe v3. this is a simple guide to configure a new silverstripe v4 project from scratch, without the confusion of upgrading.

The guide from the official lessons:
 
- The original guide: [silverstripe lessons v4](https://www.silverstripe.org/learn/lessons/v4/)

Sometimes it was useful to view the original video series:
 
- The original v3 guide, including videos: [silverstripe lessons v3](https://www.silverstripe.org/learn/lessons/v3/)

## Prerequisites

Setup a local development environment. On Windows I recommend [laragon.org](https://laragon.org/), which has all the required components:

- Apache
- MySQL
- PHP
- Composer
- Git

## Up and Running

See lesson 0 for full details on a LAMP, MAMP or WAMP stack:

- [Up and Running: Setting up a local SilverStripe dev environment](https://www.silverstripe.org/learn/lessons/v4/up-and-running-setting-up-a-local-silverstripe-dev-environment-1)

Use composer to create the silverstripe project using the silverstripe installer

### simplified setup

```shell script
composer create-project silverstripe/installer silverstrip4-example
```

Copy the `.env.example` file to make `.env`

```shell script
copy .env.example .env
```

Configure the `.env` file with the local settings (change the values of names and passwords as required):

```dotenv
# DB credentials
SS_DATABASE_CLASS="MySQLDatabase"
SS_DATABASE_SERVER="localhost"
SS_DATABASE_USERNAME="root"
SS_DATABASE_PASSWORD=""
SS_DATABASE_NAME="silverstripe4-example"

SS_ENVIRONMENT_TYPE='dev'

SS_DEFAULT_ADMIN_USERNAME='root'
SS_DEFAULT_ADMIN_PASSWORD='password'
```

Launch Laragon, start Apache and MySQL, the pretty url will automatically be created for the project `silverstripe4-example`. For other dev environments configure Apache as required.

Open the browser to <http://silverstripe4-example.test> to populate the database

## Creating your first project

Based on lesson 1 [Creating your first project](https://www.silverstripe.org/learn/lessons/v4/creating-your-first-project)

### Quick run through of first project

In your `\silverstripe4-example\app` directory, create a `templates` directory. 

```shell script
md app\templates
```

Navigate to `app\templates` and create a file called `Page.ss`. Open that file, create a basic HTML document.

```html
<html>
    <body>
        <h1>Hello, world</h1>
    </body>
</html>
```
### Activating the theme

To activate the theme, we’ll have to dig into the project directory. Open the file `theme.yml` in the `\silverstripe4-example\app\_config` directory.

Add the `app` theme and comment out `simple`

```yaml
---
Name: mytheme
---
SilverStripe\View\SSViewer:
  themes:
    - 'app'
    - '$public'
#    - 'simple'
    - '$default'
```

Rename `\silverstripe4-example\app\_config\mysite.yml` to `app.yml`

```shell script
cd silverstripe4-example\app\_config
rename mysite.yml app.yml
```

Edit `app.yml` and change the project name to app.

```yaml
---
Name: myproject
---
SilverStripe\Core\Manifest\ModuleManifest:
  project: app

# ....
```

To clear the cache, simply access any page on your site and append ?flush to the URL, e.g. <http://silverstripe4-example.test?flush>

The website will display **Hello, world**

Next configure PSR-4 autoloading. Open `\silverstripe4-example\composer.json`. In particular the **"autoload":** and **app.yml**

```json
{
    "name": "silverstripe/installer",
    "type": "silverstripe-recipe",
    "description": "The SilverStripe Framework Installer",
    "require": {
        "php": ">=7.1.0",
        "silverstripe/recipe-plugin": "^1.2",
        "silverstripe/recipe-cms": "4.5.2@stable",
        "silverstripe-themes/simple": "~3.2.0"
    },
    "require-dev": {
        "phpunit/phpunit": "^5.7"
    },
    "extra": {
        "resources-dir": "_resources",
        "project-files-installed": [
            "app/.htaccess",
            "app/_config.php",
            "app/_config/app.yml",
            "app/src/Page.php",
            "app/src/PageController.php"
        ],
        "public-files-installed": [
            ".htaccess",
            "index.php",
            "web.config"
        ]
    },
    "autoload": {
        "psr-4": {
            "SilverStripe\\Lessons\\": "app/src/"
        }
    },
    "config": {
        "process-timeout": 600
    },
    "prefer-stable": true,
    "minimum-stability": "dev"
}
```

## Migrating static templates into your theme

- Based on lesson 2 [Migrating static templates into your theme](https://www.silverstripe.org/learn/lessons/v4/migrating-static-templates-into-your-theme-1)

Download the zip file from <https://github.com/silverstripe/one-ring-rentals>

Create a folder `static` in `\silverstripe4-example\public`

```shell script
md public\static
```

Unzip the `one-ring-rentals.zip`, in a temp directory, and copy the `static` folder into the newly created `static` folder.

Open the browser to <http://silverstripe4-example.test/static/default.html> to view the content.

Open `silverstripe4-example\app\templates\Page.ss`

Copy the contents of `public\static\default.html` into `app\templates\Page.ss` (the file created in lesson one with "hello world")

Copy the folders `css`, `fonts`, `images` and `js` from `public\static` to `public`, rename `js` to `javascript`

Open <http://silverstripe4-example.test/> and the default page will be the same as the static page.

## Add dynamic content

Some code snippets were hard to follow, I have expanded the scope of these snippets to make the code block easier to identify.

- Based on lesson 3 [Migrating static templates into your theme](https://www.silverstripe.org/learn/lessons/v4/migrating-static-templates-into-your-theme-1)

Update the nav menu with Dynamic content from Silverstripe. 

- **<% loop $Menu(1) %>** Begins a loop through all the menu items, repeating all the HTML that is in the loop for each one. By passing (1) as an argument, we are asking the CMS to give us all the pages at level 1 of the hierarchy. Changing that to (2) would give us all the pages at the second level of the hierarchy in the current section, and so on.
- **$Link** The link to the page in the current iteration of the loop. 
- **$Title** The title of the page in the current iteration of the loop
- **$MenuTitle** SilverStripe distinguishes between the title of a page (i.e. in your `<h1>` tag) and the title that should appear in the context of navigation. Often times these are the same, but since the user is given the option to customise the title in menus, we use the `$MenuTitle` variable here.
- **$LinkingMode** A helper method that indicates the state of our menu. For each item in the list, this method will return one of three strings:
  - **link**: the page is not active
  - **current**: this is the current page
  - **section**: the current page is a descendant of this page (i.e. on the URL /about-us/company, the "company" page is current, and the "about-us" page is "section."

```html
<!-- BEGIN MAIN MENU -->
<nav class="navbar">
    <button id="nav-mobile-btn"><i class="fa fa-bars"></i></button>

    <ul class="nav navbar-nav">
        <% loop $Menu(1) %>
            <li><a class="$LinkingMode" href="$Link" title="Go to the $Title page">$MenuTitle</a></li>
        <% end_loop %>
    </ul>

</nav>
<!-- END MAIN MENU -->
```

Refresh the page. You should now see the three default pages SilverStripe creates for you in the primary navigation: Home, About Us, and Contact Us.

Add `<% base_tag %>` to the top of the html, under the `<head>` tag.

```html
<head>
    <meta charset="utf-8" />

    <!-- Page Title -->
    <title>One Ring Rentals - Home</title>

    <% base_tag %>
    $MetaTags
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
```

We can update our `<h1>` tag to use the $Title variable.

```html
<h1 class="page-title">$Title</h1>
```

Replace the contents of `<div class="breadcrumb">` with `$Breadcrumbs`.

```html
<div class="breadcrumb">
    $Breadcrumbs
</div>
```

Replace the contents of `<div class="main col-sm-8">` with `$Content`.

Let's look quickly at the login page to the CMS by accessing the `/admin/` URL. Notice that we're not presented with any login form. In order to get the form to show, we'll need to add a `$Form` variable, which primarily serves as a placeholder for the login form. 

```html
<div class="main col-sm-8">
    $Content
    $Form
</div>
```

Earlier in this tutorial we created a loop for primary navigation using $Menu(1). Similarly, we can create subnavigation using $Menu(2). We don't want to include this block of content unless subnavigation exists, so we'll wrap the whole thing in an <% if $Menu(2) %> block.

Replace the contents of the sidebar as follows:

```html
<div class="sidebar gray col-sm-4">
    <% if $Menu(2) %>
      <h3>In this section</h3>
        <ul class="subnav">  
          <% loop $Menu(2) %>
            <li><a class="$LinkingMode" href="$Link">$MenuTitle</a></li>
          <% end_loop %>
        </ul>
    <% end_if %>
</div>
```

We want to make sure this links to the base URL of our website. Let's use the `$AbsoluteBaseURL` variable in the link around the logo.

```html
<div class="block col-sm-3">
    <a href="#"><img src="images/logo.png" alt="One Ring Rentals" /></a>
    <a href="$AbsoluteBaseURL"><img src="images/logo.png" alt="One Ring Rentals" /></a>
    <br><br>
    <p>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam commodo eros nibh, et dictum elit tincidunt eget.
        Pellentesque volutpat quam dignissim, convallis elit id, efficitur sem. Vivamus ac scelerisque sem. Aliquam sed
        enim rutrum nibh gravida pellentesque nec at metus. In hac habitasse platea dictumst. Etiam in rhoncus mi. In
        hac habitasse platea dictumst. Mauris congue blandit venenatis.
    </p>
</div>
```

## Continue Learning

The remaining lessons could be followed without too much problem, the main gotchas were:
 
- Importing images:
  - I couldn't find the source of the original images
  - The work around was to use my own, however, they had to be uploaded one by one.
- Importing records e.g. to have data for filtering or pagination. (i.e. using SQL import): 
  - This didn't work, I suspect the table names or versioning were different.
  - The work around was to manually type in some records.
- Some code snippets weren't always clear which files was being editing.
  - I viewed the v3 videos to confirm.
 
I hope this setup helps new learners to set up Silverstripe and following the remaining lessons.
