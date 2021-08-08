---
title: Standard setup for PHP projects 2021 
date: 2021-05-23 08:52:27 
tags: [Composer, Docker, Easy Coding Standard (ECS), PHP, PHPStan, PhpStorm, PHPUnit, Silverstripe, Xdebug]
categories: [Standard Setup]
---

The focus of this blog is to help set up PHP Projects in PhpStorm, in particular a [Silverstripe](https://www.silverstripe.org/) project. I have also included snippets from my side-projects. I hope the information will be useful for other PHP projects.

This is a follow-up to my blog [Standard Setup for PHP projects](/2020/06/01/Standard-Setup-for-PHP-Projects/) from 2020. There have been several changes, to config files in particular, easy coding standard yml files to php files, which now allow code completion, amongst other benefits. Xdebug is now version 3, which has different configuration. I Have also being using Docker since July 2020, so have some useful docker containers, which include many of the standards I'm looking for.

## Developer environments

### Windows

On my works windows laptop I primarily use [Laragon](https://laragon.org/). I find it has a good set of development tools, including: PHP, MySQL, Apache, Node, Git, Composer, automatic host file updating, pretty urls, and many other good reasons.

### Linux

On my personal laptop I have a duel boot configuration. Windows has Laragon, Linux Pop_OS! Has [Docker](https://www.docker.com/). When I upgraded my laptop, last year, I fitted additional RAM and an additional SSD, which [I installed Pop_OS!](Pop-OS-new-install.md). I never installed PHP, MySQL or Apache. I installed Docker instead. I mostly use the Laptop with Linux Pop_OS! I find its quicker, easy to use, and it uses less RAM.

### Integrated Developer Environment (IDE)

My go to Integrated Developer Environment (IDE), for the last two years is [PhpStorm](https://www.jetbrains.com/phpstorm/). The learning curve to get the best out of it, is well worth the effort. After all it is not only a code editor, but has Git, Database, terminal and debugging built in. The stand out tools are the code completion and refactoring.

I have many plugins, to many to name. Here are some I find particularly useful:

- [Php Inspections (EA Extended)](https://plugins.jetbrains.com/plugin/7622-php-inspections-ea-extended-), open-source Static Code Analyzer.
- [Tabnine AI Autocomplete: JavaScript .. PHP](https://plugins.jetbrains.com/plugin/12798-tabnine-ai-autocomplete-javascript-c-python-ruby-rust-go-php--), the free version offers two autocompletion options.

I make all my notes using Markdown and store them in Scratches, this is one of the most underrated features of PhpStorm, these notes are available across all my projects.

I still have [VS Code](https://code.visualstudio.com/) as a backup, on Windows I also have [Notepad++](https://notepad-plus-plus.org/), if for some unusual reason I don't have PhpStorm open and want to take a quick peek at a file then the lightweight and speed of Notepad++ is useful.

## Composer

[Composer](https://getcomposer.org/) is the dependency manager for PHP. It also provides PSR-4 PHP autoloader.

### Switching versions

Composer is now in version 2, however some code bases will require version 1. To swap between the versions use the following commands:

- Switch to version 1:

```shell
composer self-update --1
```

- Switch to version 2:

```shell
composer self-update --2
```

### Composer Docker image

Composer has several images available on [docker hub](https://hub.docker.com/r/composer/composer).

```sh
docker pull composer/composer
docker run --rm -it -v "$(pwd):/app" composer/composer -V
Composer version 2.0.14 2021-05-21 17:03:37
```

To add Composer to an existing **Dockerfile**:

```Dockerfile
COPY --from=composer/composer /usr/bin/composer /usr/bin/composer
```

Read the docker [description](https://hub.docker.com/r/composer/composer) for further information.

Example snippet fo a **composer.json**:

```json
{
  "name": "emilybache/yatzy-refactoring-kata",
  "description": "Kata to practice refactoring",
  "license": "MIT",
  "require": {
    "php": "^7.4|^8.0"
  },
  "require-dev": {
    "phpunit/phpunit": "^9.5",
    "phpstan/phpstan": "^0.12.74",
    "phpstan/phpstan-phpunit": "^0.12.17",
    "symplify/easy-coding-standard": "^9.0",
    "symplify/phpstan-extensions": "^9.0"
  },
  "autoload": {
    "psr-4": {
      "Yatzy\\": "src/"
    }
  },
  "autoload-dev": {
    "psr-4": {
      "Yatzy\\Tests\\": "tests/"
    }
  },
  "scripts": {
    "checkcode": "phpcs src tests --standard=PSR12",
    "fixcode": "phpcbf src tests --standard=PSR12",
    "test": "phpunit",
    "tests": "phpunit",
    "test-coverage": "phpunit --coverage-html build/coverage",
    "check-cs": "ecs check --ansi",
    "fix-cs": "ecs check --fix --ansi",
    "phpstan": "phpstan analyse --ansi"
  }
}
```

## .editorconfig

Example **.editorconfig** file. Normally found in the root of a project.

```ini
# For more information about the properties used in
# this file, please see the EditorConfig documentation:
# http://editorconfig.org/

root = true

[*]
charset = utf-8
end_of_line = lf
indent_size = 4
indent_style = space
insert_final_newline = true
trim_trailing_whitespace = true

[*.md]
trim_trailing_whitespace = false

[*.{yml,json,ss}]
indent_size = 2

# The indent size used in the `package.json` file cannot be changed
# https://github.com/npm/npm/pull/3180#issuecomment-16336516
[composer.json]
indent_size = 4

[*.ss]
max_line_length = 999
```

The above is a good example of how file can have a global config, then more granular configs can be applied. PhpStorm will read the config and automatically apply the settings.

## Xdebug

[Xdebug](https://xdebug.org/docs/) has been changed from version 2 to 3. It can be used to [step-debug](https://xdebug.org/docs/step_debug) PHP scripts, report [code coverage](https://xdebug.org/docs/code_coverage) and now provides [development aids](https://xdebug.org/docs/develop). However, due to how it analyses the script it can make PHP slow! Xdebug's set-debugging and code coverage should only be enabled when they are required.

Follow the [installation](https://xdebug.org/docs/install) instructions and add the following to your **php.ini**:

```ini
[Xdebug]
; zend_extension=/wherever/you/put/it/xdebug
; e.g.
; Windows using Laragon:
zend_extension = C:\laragon\bin\php\php-7.4.4-Win32-vc15-x64\ext\php_xdebug-3.0.4-7.4-vc15-x86_64.dll
; Linux with PHP 8:
; zend_extension = /usr/lib/php8/modules/xdebug.so

xdebug.mode = coverage,debug,develop
; Linux: change 'pop-os' to your host name
xdebug.client_host = pop-os
; windows and mac:
; xdebug.client_host=localhost
xdebug.client_port = 9003
xdebug.start_with_request = yes
```

### Xdebug with Docker

PHP docker containers can have Xdebug installed as follows:

```Dockerfile
# Buster (FROM brettt89/silverstripe-web:7.4-apache):
RUN install-php-extensions xdebug
# Alpine (FROM php:8.0-cli-alpine3.13):
RUN apk add --no-cache php8-pecl-xdebug \
    && docker-php-ext-enable /usr/lib/php8/modules/xdebug.so
```

The extension can be enabled using environment variables:

```Dockerfile
ENV XDEBUG_CONFIG="client_host=pop-os" \
  #      windows & mac:
  #      XDEBUG_CONFIG= "client_host=host.docker.internal"
    XDEBUG_MODE="develop"
#    XDEBUG_MODE="coverage,debug,develop"
```

Alternatively, the extension can be enabled using environment variables:

**docker-compose.yml**

```yml
version: "3.3"
services:
  silverstripe:
    image: brettt89/silverstripe-web:7.4-apache
    ports:
      - "80:80"
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
      - XDEBUG_CONFIG="client_host=pop-os"
      - XDEBUG_MODE="develop"

# database...
```

### Setup PhpStorm

PhpStorm is my IDE of choice for PHP development. Here are some tips for configuring it per project.

#### Configuring Xdebug

**TL;DR** (parts copied from PhpStorm Tutorials, link to the full version below)

1. In the **Settings/Preferences** dialog Ctrl+Alt+S, select **Languages & Frameworks | PHP**.
2. Check the Xdebug installation associated with the selected PHP interpreter:

   a. On the **PHP** page, choose the relevant PHP installation from the **CLI Interpreter** list and click the Browse button next to the field.

   b. The **CLI Interpreters** dialog that opens shows the following:

   i. The version of the selected PHP installation. (e.g. **C:\laragon\bin\php\php-7.4.4-Win32-vc15-x64\php.exe**)

   ii. The name and version of the debugging engine associated with the selected PHP installation (Xdebug). (e.g. **C:\laragon\bin\php\php-7.4.4-Win32-vc15-x64\ext\php_xdebug.dll**)

   iii Once set click **OK**.

3. Define the Xdebug behaviour. Click Debug under the PHP node (**Languages & Frameworks | PHP | Debug**.). On the Debug page that opens, specify the following settings in the Xdebug area:

* Check the Pre-configuration has been complete (Xdebug ins installed, Install browser toolbar, Enable listening for PHP Debug connections and Start debug session)
* Under the XDebug heading, Choose the Debug Port field (**default is 9000,9003**). This must be exactly the same port number specified in the php.ini file: **xdebug.remote_port =9003**
* To accept any incoming connections, select the **Can accept external connections checkbox.** (**Default**)
* Select the **Force break at the first line when no path mapping is specified** checkbox to have the debugger stop as soon as it reaches and opens a file that is not mapped to any file in the project on the Servers page. (**Default**)
* Click **OK**

#### Using debug mode

Set a breakpoint in the file to be inspected.

Open your php file, e.g. **public/index.php**, wait for the file to open, then in to top right there will be a floating bar with a list of browsers. Click Chrome (**Alt+F2** + Choose Chrome)

Chrome browser will launch and open the projects webpage. If the Debug icon isn't already green, click the **Debug** icon for **Xdebug helper** extension. From the drop down list click **Debug** option, the icon will then display green.

Navigate the project's website, to the page which uses the file that has the breakpoint set. As soon as the page is hit PhpStorm will open \(it may be behind the browser\).

In PhpStorm, accept the connection \(this warning normally only displays the first hit and accepted once\).

Debug information will display in the console, including the option to inspect variables and evaluate.

#### Further details: How to Debug

For the full version of the above see:

- [Configuring Xdebug in PhpStorm](https://www.jetbrains.com/help/phpstorm/configuring-xdebug.html) 
- [Browser Debugging Extensions](https://www.jetbrains.com/help/phpstorm/browser-debugging-extensions.html), click the link for Xdebug for Chrome and install **Xdebug Helper**.
- [Youtube: Step Into Debugging with PhpStorm](https://www.youtube.com/watch?v=GokeXqI93x8) by Gary Hockin, 58 min video on Debugging with Xdebug 2.

#### Strict mode

PHPStorm has an inspection to set strict mode.

- [Full article Project Wide PHP 7 Strict Types in PhpStorm 2016.3](https://blog.jetbrains.com/phpstorm/2016/11/project-wide-php-7-strict-types-in-phpstorm-2016-3/) by Gary Hockin

**TL&DR;**

**Strict types declaration** setting can be found under **Type compatibility** in the **Inspections** pane of the **Preferences** window.

**Or** double shift search for **Missing Strict types declaration** tick the inspection.

To run the inspection against whole project (code base): **CTRL + ALT + SHIFT + I** or double shift search for **run inspection by name**. Search for **missing strict type declaration**, **Enter** for whole project. The inspection will run, click on each file and click **Add strict types declaration**

## Easy Coding Standard (ECS)

> The easiest way to start using PHP CS Fixer and PHP_CodeSniffer with 0-knowledge

Github: [symplify/easy-coding-standard](https://github.com/Symplify/EasyCodingStandard)

ECS is my goto coding standard tool, it includes PHP CS Fixer and PHP_CodeSniffer, meaning I can use existing standards. I use it on every project!

### Install ECS using Composer

```sh
composer require --dev symplify/easy-coding-standard
```

### Docker image with ECS

My favourite Docker PHP tool, packed with useful tools, including ECS is [Docker hub jakzal/phpqa](https://hub.docker.com/r/jakzal/phpqa/)

```shell
docker pull jakzal/phpqa:php7.4-alpine
docker run -it --rm -v "$(pwd):/project" -v "$(pwd)/tmp-phpqa:/tmp" \
      -w /project jakzal/phpqa:php7.4-alpine ecs --version
```

### Example `ecs.php` file

**Note:** ECS has changed from a **yml** file to a **php** file, which allows code completion, amongst other things.

**ecs.php**

```php
<?php

declare(strict_types=1);

use PhpCsFixer\Fixer\ArrayNotation\ArraySyntaxFixer;
use PhpCsFixer\Fixer\Operator\BinaryOperatorSpacesFixer;
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;
use Symplify\EasyCodingStandard\ValueObject\Option;
use Symplify\EasyCodingStandard\ValueObject\Set\SetList;

return static function (ContainerConfigurator $containerConfigurator): void {
    $services = $containerConfigurator->services();

    $services->set(ArraySyntaxFixer::class)
        ->call('configure', [[
            'syntax' => 'short',
        ]]);


    // align key value pairs (mostly)
    $services->set(BinaryOperatorSpacesFixer::class)
        ->call('configure', [[        
            // Likely problems are pipe operators
            // if this is a problem change 'default' => 'single'
            // and uncomment this lines:
            // 'operators' => [
            //                  '|' => 'none',
            //                  '=>' => 'align_single_space_minimal'
            //               ],
            'default' =>'align_single_space_minimal',
        ]]);

    // add declare(strict_types=1); to all php files:
    $services->set(DeclareStrictTypesFixer::class);
    
    $parameters = $containerConfigurator->parameters();
    $parameters->set(Option::PATHS, [
        __DIR__ . '/src',
        __DIR__ . '/tests',
    ]);

    $parameters->set(Option::SETS, [
        // run and fix, one by one
        SetList::SPACES,
//        SetList::ARRAY,
//        SetList::DOCBLOCK,
//        SetList::NAMESPACES,
//        SetList::CONTROL_STRUCTURES,
//        SetList::CLEAN_CODE,
//        SetList::STRICT,
//        SetList::PSR_12,
//        SetList::PHPUNIT,
    ]);

    $parameters->set(Option::INDENTATION, "spaces");

    $parameters->set(Option::LINE_ENDING, "\n");
};
```

### Example projects with ECS included

I always find it useful to look at existing projects with working code, see some examples from GitHub:

- Personal project:
  - [Lumen API using TDD](https://github.com/Pen-y-Fan/lumen-api-using-tdd)
- Kata:
  - [Emily Bache - GildedRose Refactoring Kata](https://github.com/emilybache/GildedRose-Refactoring-Kata/blob/main/php/ecs.php)
- LMC:
  - [lmc eu/php coding standard](https://github.com/lmc-eu/php-coding-standard/blob/main/ecs.php) - heavily commented!

### Run ECS

```shell
vendor/bin/ecs check
vendor/bin/ecs check --fix
```

If **composer.json** has been configured with scripts, as above:

```shell
composer check-cs
composer fix-cs
```

Alias:

```shell
alias cc="composer check-cs"
alias fc="composer fix-cs"
```

- Mac and Linux: add the alias to **~/.bash_aliases**.
- Windows: create files **cc.bat** and **fc.bat** and add the composer calls.

Then run with **cc** and **fc**!

## PHPStan

> PHPStan focuses on finding errors in your code without actually running it. It catches whole classes of bugs even before you write tests for the code. It moves PHP closer to compiled languages in the sense that the correctness of each line of the code can be checked before you run the actual line.

* Github: [phpstan/phpstan](https://github.com/phpstan/phpstan)

### Install PHPStan using Composer

```sh
composer require phpstan/phpstan --dev
# phpunit analysis:
composer require phpstan/phpstan-phpunit --dev
# additional extensions:
composer require symplify/phpstan-extensions --dev
```

### Docker image with PHPStan

My favourite Docker PHP tool, packed with useful tools, including PHPStan is [Docker hub jakzal/phpqa](https://hub.docker.com/r/jakzal/phpqa/)

```shell
docker pull jakzal/phpqa:php7.4-alpine
docker run -it --rm -v "$(pwd):/project" -v "$(pwd)/tmp-phpqa:/tmp" \
      -w /project jakzal/phpqa:php7.4-alpine phpstan --version
```

One of the benefits of using the docker image is PHPStan doesn't need to be installed as a dev dependency. Less to install and no dependency clashes!

### Example `phpstan.neon` file

PHPStan expects a **phpstan.neon** file in the root of the project.

**phpstan.neon**

```yaml
includes:
  - vendor/symplify/phpstan-extensions/config/config.neon
  - vendor/phpstan/phpstan-phpunit/extension.neon

parameters:
  paths:
    - src
    - tests

  # The level 8 is the highest level
  level: 8

  # Larstan recommendation:
  checkMissingIterableValueType: false

  # Ignore generic class Ds\Map
  checkGenericClassInNonGenericObjectType: false

  ignoreErrors:
    # Magic method is used is simulate enum
    - '#Call to an undefined static method#'
    -
      message: '#PHPDoc tag @method has invalid value#'
      paths:
        - src\Model\SpecialOfferType.php
        - src\Model\ProductUnit.php
  # buggy

  # mixed

  # cache buggy

  # tests

  # iterable
```

The above includes placeholders (buggy/mixed etc) for ignored files or rules. See the documentation for how to add.

### Example projects with PHPStan included

I always find it useful to look at existing projects with working code, see some examples from GitHub:

- Personal project:
  - [Watson Text To Speech using PHP](https://github.com/Pen-y-Fan/watson-text-to-speech-php/blob/master/phpstan.neon)
- Kata:
  - [Emily Bache - SupermarketReceipt Refactoring Kata](https://github.com/emilybache/SupermarketReceipt-Refactoring-Kata/blob/main/php/phpstan.neon)
- Others:
  - [lmc eu/php coding standard](https://github.com/lmc-eu/php-coding-standard/blob/main/phpstan.neon)
  - [KnpLabs/DoctrineBehaviors](https://raw.githubusercontent.com/KnpLabs/DoctrineBehaviors/master/phpstan.neon)

### Run PHPStan

```shell
vendor/bin/phpstan analyse --error-format symplify
```

If **composer.json** has been configured with scripts, as above:

```shell
composer phpstan
```

Alias:

```shell
alias ps="composer phpstan"
```

- Mac and Linux: add the alias to **~/.bash_aliases**.
- Windows: create files **ps.bat** and add the composer calls.

Then run with `ps`!

## PHPUnit

> PHPUnit is a programmer-oriented testing framework for PHP. It is an instance of the xUnit architecture for unit testing frameworks.

* [phpunit/phpunit](https://phpunit.readthedocs.io/en/9.5/index.html)

### Installation of PHPUnit using Composer

```shell
composer require --dev phpunit/phpunit ^9.5
```

### Docker image with PHPUnit

My favourite Docker PHP tool, packed with useful tools, including several versions of PHPUnit is [Docker hub jakzal/phpqa](https://hub.docker.com/r/jakzal/phpqa/)

```shell
docker pull jakzal/phpqa:php7.4-alpine
docker run -it --rm -v "$(pwd):/project" -v "$(pwd)/tmp-phpqa:/tmp" \ 
      -w /project jakzal/phpqa:php7.4-alpine phpunit --version
```

One of the benefits of using the docker image is less dev dependencies.

### Example `phpunit.xml` or `phpunit.xml.dist` file

Example **phpunit.xml** from [emilybache/Theatrical-Players-Refactoring-Kata](https://github.com/emilybache/Theatrical-Players-Refactoring-Kata/blob/main/php/phpunit.xml).

**phpunit.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<phpunit xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="https://schema.phpunit.de/9.3/phpunit.xsd"
         bootstrap="vendor/autoload.php"
         colors="true">
    <coverage processUncoveredFiles="true">
        <include>
            <directory suffix=".php">./src</directory>
        </include>
    </coverage>
    <testsuites>
        <testsuite name="AllTests">
            <directory>./tests</directory>
        </testsuite>
    </testsuites>
</phpunit>
```

- Add `/build/` to **.gitignore**

```shell script
echo /build/ >> .gitignore
```

### Example projects with PHPUnit included

I always find it useful to look at existing projects with working code, see some examples from GitHub:

- Personal project:
  - [Watson Text To Speech using PHP](https://github.com/Pen-y-Fan/watson-text-to-speech-php/blob/master/phpunit.xml)
- Kata:
  - [Emily Bache - SupermarketReceipt Refactoring Kata](https://github.com/emilybache/SupermarketReceipt-Refactoring-Kata/blob/main/php/phpunit.xml)
- Others:
  - [lmc eu/php coding standard](https://github.com/lmc-eu/php-coding-standard/blob/main/phpunit.xml.dist)
  - [laravel/cashier-mollie](https://github.com/laravel/cashier-mollie/blob/develop/phpunit.xml.dist) - includes how to run with SQLite in memory database

### Run PHPUnit

```shell
vendor/bin/phpunit
```

If **composer.json** has been configured with scripts, as above:

```shell
composer phpunit
```

Alias:

```shell
alias pu="composer phpunit"
```

- Mac and Linux: add the alias to **~/.bash_aliases**.
- Windows: create files **pu.bat** and add the composer calls.

Then run with `pu`!

## Docker

I wrote at the start, Docker is my only development environment on my Linux Pop_OS! Laptop. This layer of complexity is sometimes frustrating. Especially when Laragon makes my Windows development environment so easy. I have persisted, primarily to challenge myself to learn Docker.

### Dockerfile

There are many flavours of Dockerfiles, the smallest, most lightweight are generally Alpine images. Here are some **Dockerfiles** I have curated.

#### PHP 8 Alpine CLI with xdebug and intl

Dockerfile for PHP 8 Alpine with xdebug and intl, useful for Kata. See [Yatzy Refactoring Kata php](https://github.com/Pen-y-Fan/Yatzy-Refactoring-Kata-php/blob/php/php/Dockerfile)

**Dockerfile**

```Dockerfile
FROM php:8.0-cli-alpine3.13

# user, uid and gid are the same as my Linix. This has no effect on windows
ARG USER=michael
ARG UID=1000
ARG GID=1000

# 'pop-os' is my Linux host name, on your Linux change to your host name! On Windows and Mac change to:
    # xdebug.client_host=host.docker.internal
ENV xdebug.mode=coverage,debug,develop \
    xdebug.client_host=pop-os \
    xdebug.client_port=9003 \
    xdebug.start_with_request=yes

# create a system user with home folder, uid:gid 1000:1000, no password called michael
RUN addgroup -g $GID $USER \
    && adduser \
    --system \
    --disabled-password \
    --gecos "" \
    --home "/home/$USER" \
    --ingroup "$USER" \
    --no-create-home \
    --uid "$UID" \
    "$USER"

RUN apk add --no-cache php8-pecl-xdebug php8-intl \
    && docker-php-ext-enable /usr/lib/php8/modules/xdebug.so /usr/lib/php8/modules/intl.so

# smoke test
RUN php -v \
    && php -m

WORKDIR /app
```

- `docker build -t php8-cli-alpine:local .`
- `docker run -it --rm -v $(pwd):/app -u 1000:1000 -w /app php8-cli-alpine:local /bin/sh`
- PhpStorm: Add php8-cli-alpine:local as the CLI Interpreter
- Configure tests to use this as the PHP Interpreter. 

#### PHP 7.4 Alpine with Apache, PDO and intl

Used on [PHP AJAX CRUD using jQuery UI Demo](https://github.com/Pen-y-Fan/php-ajax-crud-using-jquery-ui-demo), see the repo for the docker-compose, which includes MySQL 5.7.0. **Note** the **start.sh** file is also needed to run!

**Dockerfile**

```Dockerfile
FROM alpine:edge
MAINTAINER Paul Smith <pa.ulsmith.net>
# Original docker iamge source: https://github.com/ulsmith/alpine-apache-php7

# Add repos
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Add basics first
RUN apk update && apk upgrade && apk add \
	bash apache2 php7-apache2 curl ca-certificates openssl openssh git php7 php7-phar php7-json php7-iconv php7-openssl tzdata openntpd nano

# Add Composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Setup apache and php
RUN apk add \
	php7-ftp \
	php7-xdebug \
	php7-mcrypt \
	php7-mbstring \
	php7-soap \
	php7-gmp \
	php7-pdo_odbc \
	php7-dom \
	php7-pdo \
	php7-zip \
	php7-mysqli \
	php7-sqlite3 \
	php7-pdo_pgsql \
	php7-bcmath \
	php7-gd \
	php7-odbc \
	php7-pdo_mysql \
	php7-pdo_sqlite \
	php7-gettext \
	php7-xml \
	php7-xmlreader \
	php7-xmlwriter \
	php7-tokenizer \
	php7-xmlrpc \
	php7-bz2 \
	php7-pdo_dblib \
	php7-curl \
	php7-ctype \
	php7-session \
	php7-redis \
	php7-exif \
	php7-intl \
	php7-fileinfo \
	php7-ldap \
	php7-apcu

# Problems installing in above stack
RUN apk add php7-simplexml

RUN cp /usr/bin/php7 /usr/bin/php \
    && rm -f /var/cache/apk/*

# Add apache to run and configure
RUN sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_module/LoadModule\ session_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_cookie_module/LoadModule\ session_cookie_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_crypto_module/LoadModule\ session_crypto_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ deflate_module/LoadModule\ deflate_module/" /etc/apache2/httpd.conf \
    && sed -i "s#^DocumentRoot \".*#DocumentRoot \"/app/public\"#g" /etc/apache2/httpd.conf \
    && sed -i "s#/var/www/localhost/htdocs#/app/public#" /etc/apache2/httpd.conf \
    && printf "\n<Directory \"/app/public\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf

RUN mkdir /app && mkdir /app/public && chown -R apache:apache /app && chmod -R 755 /app && mkdir bootstrap
ADD start.sh /bootstrap/
RUN chmod +x /bootstrap/start.sh

ADD /public /app/public
RUN chown -R apache:apache /app
WORKDIR /app

EXPOSE 80
ENTRYPOINT ["/bootstrap/start.sh"]
```

### docker-compose.yml

To get the most out of a development environment. It should be easy to “spin up”, docker-compose files take the lengthy Docker run commands, The lay them out into easy to read files, which are easy to edit.

Example from [Pen-y-Fan / php-ajax-crud-using-jquery-ui-demo](https://github.com/Pen-y-Fan/php-ajax-crud-using-jquery-ui-demo)

You can see two Apache servers, sharing the same database. One has XDebug enabled, which makes it slow, but easy to run step debugging. I only need to switch from **localhost:8080** to **localhost:8081** to start debugging.

**docker-compose.yml**

```yaml
version: "3"
services:
  ajaxcrud:
    image: apachephp:local
# build: ./
    labels:
      - "traefik.backend=ajaxcrud"
  #    - "traefik.frontend.rule=Host:ajaxcrud.docker.localhost"
    environment:
      - MYSQL_HOST=database
      - APACHE_SERVER_NAME=ajaxcrud.docker.localhost
      - PHP_SHORT_OPEN_TAG=On
      - PHP_ERROR_REPORTING=E_ALL
      - PHP_DISPLAY_ERRORS=On
      - PHP_HTML_ERRORS=On
      # Xdebug is disabled use ajaxcrudx for debugging
    networks:
      - default
    ports:
      - "8080:80"
    volumes:
      - ./:/app
      - ./tmp-phpqa:/tmp
    working_dir: /app
    depends_on:
      - database
    # ADD in permission for setting system time to host system time
    cap_add:
      - SYS_TIME
      - SYS_NICE

# Enable Xdebug and use port 8081
  ajaxcrudx:
    image: apachephp:local
    labels:
      - "traefik.backend=ajaxcrudx"
    #    - "traefik.frontend.rule=Host:ajaxcrud.docker.localhost"
    environment:
      - MYSQL_HOST=database
      - APACHE_SERVER_NAME=ajaxcrudx.docker.localhost
      - PHP_SHORT_OPEN_TAG=On
      - PHP_ERROR_REPORTING=E_ALL
      - PHP_DISPLAY_ERRORS=On
      - PHP_HTML_ERRORS=On
      - PHP_XDEBUG_ENABLED=On
    networks:
      - default
    ports:
      - "8081:80"
    volumes:
      - ./:/app
      - ./tmp-phpqa:/tmp
    working_dir: /app
    depends_on:
      - database
    # ADD in permission for setting system time to host system time
    cap_add:
      - SYS_TIME
      - SYS_NICE

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

#networks:
#  default:
#    external:
#      name: docker_docker-localhost
```

### Makefile

**Makefile** allow a consistent and easy way for me to “spin up” the different environments. It doesn't matter if it is a LAMP stack or Node, I can run `make up` to start things off. 

Example used on [PHP AJAX CRUD using jQuery UI Demo](https://github.com/Pen-y-Fan/php-ajax-crud-using-jquery-ui-demo)

Usage:

- **build-image** - build the local image ready for docker-compose
- **make up** - starts the docker-compose in the same directory in demon (background)
- **make down** - stops the docker-compose
- **make seed** - Create the table and seed the database with three records
- **make shell** - opens a sh terminal in the running ajaxcrud container as a standard user
- **make shell-root** -  opens a sh in ajaxcrud container as root user
- **make shell-web** -  opens a sh in ajaxcrud container as www user
- **make up-f** - start the docker-compose in foreground (useful for error messages)
- **make tests** - run phpunit tests
- **make test-coverage** - phpunit coverage html report will be created in build/coverage
- **make phpstan** - static analysis using phpstan
- **make checkcode** - check code using php_code sniffer (phpcbf)
- **make fixcode** - fix code using php_code sniffer (phpcbf)
- **make check-cs** - check code using easy coding standards (ecs)
- **make fix-cs** - fix code using easy coding standards (ecs)
- **grumphp** - manually run grumphp (runs: phpunit, ecs and phpstan)
- **toolbox** - shell access to the toolbox
- **cypress-register** - register Cypress with xhost to allow Docker to display GUI app on the host's monitor
- **cypress** - run Cypress end to end testing

**Makefile**

```Makefile
# Duster: www-data:www-data is 33:33
# Alpine: apache:apache is 100:101
APACHE_UID = 100
APACHE_GID = 101

build-image:
	docker build -t apachephp:local .

up:
	docker-compose up --remove-orphans -d
up-f:
	docker-compose up --remove-orphans
down:
	docker-compose down --remove-orphans
seed:
	 docker-compose exec -u ${APACHE_UID}:${APACHE_GID} ajaxcrud php /app/build_db.php
shell:
	docker-compose exec -u ${shell id -u}:${shell id -g} ajaxcrud sh
shell-root:
	docker-compose exec -u 0:0 ajaxcrud sh
shell-web:
	docker-compose exec -u ${APACHE_UID}:${APACHE_GID} ajaxcrud sh

chown:
	docker-compose exec -u 0:0 ajaxcrud chown -R ${shell id -u}:${shell id -g} ./

.PHONY : tests
tests:
	docker-compose exec -u ${shell id -u}:${shell id -g} ajaxcrud ./vendor/bin/phpunit

test-coverage:
	docker-compose exec -u ${shell id -u}:${shell id -g} \
		ajaxcrudx ./vendor/bin/phpunit --coverage-html build/coverage

phpstan:
	docker run --init -it --rm  -w /project \
		-v $(shell pwd):/project \
		-v $(shell pwd)/tmp-phpqa:/tmp \
		jakzal/phpqa:1.52-php7.4-alpine phpstan analyse

checkcode:
	docker run --init -it --rm -w /project \
		-v $(shell pwd):/project \
		-v $(shell pwd)/tmp-phpqa:/tmp \
    	jakzal/phpqa:1.52-php7.4-alpine phpcs public tests src  --standard=phpcs.xml

fixcode:
	docker run --init -it --rm  -w /project \
	 		-v $(shell pwd):/project \
	 		-v $(shell pwd)/tmp-phpqa:/tmp \
    		jakzal/phpqa:1.52-php7.4-alpine phpcbf public tests src --standard=phpcs.xml

check-cs:
	docker run --init -it --rm -w /project \
			-v $(shell pwd):/project \
			-v $(shell pwd)/tmp-phpqa:/tmp \
    		jakzal/phpqa:1.52-php7.4-alpine ecs check

fix-cs:
	docker run --init -it --rm  -w /project \
			-v $(shell pwd):/project \
			-v $(shell pwd)/tmp-phpqa:/tmp \
    		jakzal/phpqa:1.52-php7.4-alpine ecs check --fix

grumphp:
	docker run --init -it --rm -w /project \
			-v $(shell pwd):/project \
			-v $(shell pwd)/tmp-phpqa:/tmp \
			jakzal/phpqa:1.52-php7.4-alpine ./vendor/bin/grumphp run

toolbox:
	docker run --init -it --rm  -w /project \
		-v $(shell pwd):/project \
		-v $(shell pwd)/tmp-phpqa:/tmp \
		jakzal/phpqa:1.52-php7.4-alpine sh

cypress-register:
	xhost +local:`docker inspect --format='{{ .ContainerConfig.Hostname }}' cypress/included:6.6.0`

.PHONY : cypress
cypress:
	docker run -it --rm -d -e DISPLAY \
		-v $(shell pwd):/e2e \
	 	-v /tmp/.X11-unix:/tmp/.X11-unix --net=host -w /e2e \
		--entrypoint cypress cypress/included:6.6.0 open --project .

cypress-run:
	docker run -it --rm -w /e2e \
		-v $(shell pwd):/e2e \
		cypress/included:6.6.0
```

## Conclusion

I hope you find this curated list useful, I hope to continue my development and update a new list next year!
