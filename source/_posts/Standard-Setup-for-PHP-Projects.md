---
title: Standard Setup for PHP projects
date: 2020-05-31 23:38:00
tags: [Laravel, PhpStorm, PhpStan, Easy Coding Standard (ECS), PhpUnit, Rector, PHP]
categories: [Coding Standards]
---

The focus in setting up PHP Projects in PhpStorm, in particular a Laravel project.

Composer with PHP with Easy Coding Standard (ECS), PHPUnit, and PhpStan. Also, some ***simplify*** projects to allow the output to be displayed in PHPStorm.

Below are some other options, including psalm, Rector and PHP Mess Detector.

## Composer

Example snippet of a **composer.json**

```json
{
    "require-dev": {
        "phpstan/phpstan": "^0.12",
        "phpunit/phpunit": "^8.5.0",
        "squizlabs/php_codesniffer": "^3.5.3",
        "symplify/easy-coding-standard": "^7.1",
        "symplify/phpstan-extensions": "^7.1",
        "nunomaduro/larastan": "^0.5.0",
        "phpstan/phpstan-phpunit": "^0.12.2",
        "rector/rector": "0.7.26"
    },
    "scripts": {
        "checkcode": "phpcs src tests --standard=PSR12",
        "fixcode": "phpcbf src tests --standard=PSR12",
        "test": "phpunit",
        "tests": "phpunit",
        "check-cs": "ecs check src tests --ansi",
        "fix-cs": "ecs check src tests --fix --ansi",
        "phpstan": "phpstan analyse src tests --ansi --error-format symplify",
        "rector": "rector process -c rector.yaml --ansi",
        "rector:dry-run": "rector process -c rector.yaml --ansi --dry-run"
    }
}
```

## .editorconfig

Example `.editorconfig` file, normally found in the root of a project.

```text
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
indent_style = space
indent_size = 4
trim_trailing_whitespace = true

[*.md]
trim_trailing_whitespace = false
```

## Xdebug

Xdebug is used to debug PHP script, however due to how it analyses the script it makes PHP **very** slow, debugging should only enable it when debugging is required.

Add the following to the **php.ini**:

```text
[xdebug]
zend_extension=xdebug
xdebug.remote_enable=1
xdebug.remote_port=9000
```

**Note**: PhpStorm will automatically enable xdebug, when the following is configure and debugging is enable, there is no need to leave xdebug enabled in **php.ini**. To temporarily disable xdebug comment out and the line. Using Laragon: Menu > PHP > Quick settings > xdebug, click to toggle on and off. This will be the same as manually adding a **;** to the **php.ini** file:

```text
[xdebug]
;zend_extension=xdebug
...
```

### Configuring Xdebug in PhpStorm

**TL;DR** (parts copied from above PhpStorm Tutorials, full version below)

1. In the **Settings/Preferences** dialog Ctrl+Alt+S, select **Languages & Frameworks | PHP**.
2. Check the Xdebug installation associated with the selected PHP interpreter:

    a. On the **PHP** page, choose the relevant PHP installation from the **CLI Interpreter** list and click the Browse button next to the field.

    b. The **CLI Interpreters** dialog that opens shows the following:

      i. The version of the selected PHP installation. (e.g. **D:\laragon\bin\php\php-7.4.4-Win32-vc15-x64\php.exe**)

      ii. The name and version of the debugging engine associated with the selected PHP installation (Xdebug). (e.g. **D:\laragon\bin\php\php-7.4.4-Win32-vc15-x64\ext\php_xdebug.dll**)

      iii Once set click **OK**.

3. Define the Xdebug behaviour. Click Debug under the PHP node (**Languages & Frameworks | PHP | Debug**.). On the Debug page that opens, specify the following settings in the Xdebug area:

* Check the Pre-configuration has been complete (Xdebug ins installed, Install browser toolbar, Enable listening for PHP Debug connections and Start debug session)
* Under the XDebug heading, Choose the Debug Port field (**default is 9000**). This must be exactly the same port number as specified in the php.ini file: **xdebug.remote_port =9000**
* To accept any incoming connections, select the **Can accept external connections checkbox.** (**Default**)
* Select the **Force break at the first line when no path mapping is specified** checkbox to have the debugger stop as soon as it reaches and opens a file that is not mapped to any file in the project on the Servers page. (**Default**)
* Click **OK**

### Using debug mode

Set a breakpoint in the file to be inspected.

Open **public/index.php**, wait for the file to open, then in to top right there will be a floating bar with a list of browsers. Click Chrome (**Alt+F2** + Choose Chrome)

Chrome browser will launch and open the projects webpage. If the Debug icon isn't already green, click the **Debug** icon for **Xdebug helper** extension. From the drop down list click **Debug** option, the icon will then display green.

Navigate the project's website, to the page which uses the file that has the breakpoint set. As soon as the page is hit PhpStorm will open \(it may be behind the browser\).

In PhpStorm, accept the connection \(this warning normally only displays the first hit and accepted once\).

Debug information will display in the console, including the option to inspect variables and evaluate.

### More details: How to Debug

For the full version of the above see [Configuring Xdebug in PhpStorm](https://www.jetbrains.com/help/phpstorm/configuring-xdebug.html) and [Browser Debugging Extensions](https://www.jetbrains.com/help/phpstorm/2019.3/browser-debugging-extensions.html), click the link for Xdebug for Chrome and install **Xdebug Helper**.

[Youtube: Step Into Debugging with PhpStorm](https://www.youtube.com/watch?v=GokeXqI93x8) by Gary Hockin, 58 min video on Debugging.

[How to Debug using Xdebug and PHPStorm from a Remote Server](https://www.agileana.com/blog/how-to-debug-from-a-remote-server-using-xdebug-and-phpstorm/)

### Strict mode

PHPStorm has an inspection to set strict mode.

- [Full article Project Wide PHP 7 Strict Types in PhpStorm 2016.3](https://blog.jetbrains.com/phpstorm/2016/11/project-wide-php-7-strict-types-in-phpstorm-2016-3/)  by Gary Hockin

#### TL&DR;

**Strict types declaration** setting can be found under **Type compatibility** in the **Inspections** pane of the
 **Preferences** window.

**Or** double shift search for **Missing Strict types declaration** tick the inspection.

To run the inspection against the whole project (code base): **CTRL + ALT + SHIFT + I** or double shift search for
 **run inspection by name**. Search for **missing strict type declaration**, **Enter** for whole project. The inspection
  will run, click on each file and click **Add strict types declaration**

## Project specific Standards

### Laravel

Add the Laravel code standard for PHP code sniffer, static analysis for PHPStan and PHPStorm helper.

```sh
composer require --dev emielmolenaar/phpcs-laravel
composer require --dev nunomaduro/larastan
composer require --dev barryvdh/laravel-ide-helper
```

Example script to run phpcs using the phpcs-laravel standard:

```sh
phpcs --standard=phpcs-laravel
```

#### Automatic phpDoc generation for Laravel Facades (ide helper setup)

* phpDoc generation for Laravel Facades
* phpDocs for models
* PhpStorm Meta file

After updating composer, add the service provider to the `providers` array in `config/app.php`

```php
[
Barryvdh\LaravelIdeHelper\IdeHelperServiceProvider::class,
];
```

To generate helper files, run the following:

```bash
php artisan ide-helper:generate
php artisan ide-helper:models --write
php artisan ide-helper:meta
```

It is a good idea to add the generated files to .gitignore

```bash
echo /.phpstorm.meta.php >> .gitignore
echo /_ide_helper.php >> .gitignore
echo /_ide_helper_models.php >> .gitignore
```

In **PhpStorm** enable the Laravel plugin

## Shortcuts for Helpers

Create batch files in the root of the project, which work in combination with the composer scripts.

### cc.bat

Runs the composer script for ECS to check the code.

```cmd
composer check-cs 
```

### fc.bat

Runs the composer script for ECS to fix the code.

```cmd
composer fix-cs 
```

### rdr.bat

Runs the composer script for Rector for dry run. Adjust **rector.yml** as required.

```cmd
composer rector:dry-run 
```

### re.bat

Runs the composer script for Rector to fix the code (run dry run first!). Also adjust **rector.yml** as required. 

```cmd
composer rector
```

### ps.bat

Runs the composer script for PhpStan to check the code. 

```cmd
composer phpstan 
```

### pu.bat

Runs the composer script for PhpUnit. 

```cmd
composer test 
```

## PHPStan Setup

PHP Static Analysis Tool - discover bugs in your code without running it!

* Github: [phpstan/phpstan](https://github.com/phpstan/phpstan)

### Installation of PHPStan using Composer

```sh
composer require phpstan/phpstan --dev
```

### Example `phpstan.neon` file

PHPStan needs a `phpstan.neon` file an example can be found [here](https://raw.githubusercontent.com/KnpLabs/DoctrineBehaviors/master/phpstan.neon)

Example **phpstan.neon**

```yaml
includes:
    - vendor/nunomaduro/larastan/extension.neon
    - vendor/symplify/phpstan-extensions/config/config.neon
    - vendor/phpstan/phpstan-phpunit/extension.neon

parameters:
    paths:
        # Laravel
        - app 
        # Source folder, add more folder as required
        - src 
        - tests

    # The level 8 is the highest level
    level: 8

    checkGenericClassInNonGenericObjectType: false

    # Larstan recommendation:
    checkMissingIterableValueType: false

    # to allow installing with various PhpStan versions without reporting old errors here
    reportUnmatchedIgnoredErrors: false

    ignoreErrors:
        # LaraStan recommendation:
        - '#Unsafe usage of new static#'

        # Ignore errors in Laravel's Middleware classes
        -
            message: '#Method App\\Http\\Middleware\\RedirectIfAuthenticated\:\:handle\(\) has no return typehint specified#'
            path: app\Http\Middleware\RedirectIfAuthenticated.php
        -
            message: '#Method App\\Http\\Middleware\\Authenticate\:\:redirectTo\(\) should return string\|null but return statement is missing#'
            path: app\Http\Middleware\Authenticate.php

    # buggy

    # mixed

    # cache buggy

    # tests

    # iterable
```

The above includes placeholders (buggy/mixed etc) for ignored files or rules. See the documentation for how to add.

Another **PhpStan.neon** example from LaraStan:

```neon
includes:
    - ./vendor/nunomaduro/larastan/extension.neon

parameters:

    paths:
        - app

    # The level 8 is the highest level
    level: 5

    ignoreErrors:
        - '#Unsafe usage of new static#'

    excludes_analyse:
        - ./*/*/FileToBeExcluded.php

    checkMissingIterableValueType: false
```

### Alternative PhpStan script with level set to max

```text
phpstan analyse src tests --level max --error-format checkstyle
```

## PHPStorm Setup of PHPStan

### PHPStan can be used as an External Tool

Go to **Preferences > Tools > External Tools** and click **+** to add a new tool.

* Name: **PHPStan** (Can be any value)
* Description: **PHPStan** (Can be any value)
* Program: **$ProjectFileDir$/vendor/bin/phpstan.bat** (Path to `phpstan.bat` executable; On Windows path separators must be a `\`)
* Parameters: **check $FilePathRelativeToProjectRoot$** (append **--fix** to auto-fix)
* Working directory: **$ProjectFileDir$**

Press **Cmd/Ctrl + Shift + A** (Find Action), search for **phpstan**, and then hit Enter. It will run **phpstan** for all files in the project.

You can also create a keyboard shortcut in [Preferences > Keymap](https://www.jetbrains.com/help/webstorm/configuring-keyboard-and-mouse-shortcuts.html) to run **phpstan**.

### PHPStan can be used as a watcher

I have also tried setting up **PHPStan** as a [watcher](https://www.jetbrains.com/help/phpstorm/using-file-watchers.html) as follows:

* File type: **PHP**
* Scope: **All Places**
* Program: **$ProjectFileDir$/vendor/bin/phpstan**
* Arguments: **analyse**
* Working directory: **$ProjectFileDir$**
* Show console: **On error**

It runs **PHPStan** on every save, but only opens the console when PHPStan detects an error. Not as good as integrated analysis, but a good compromise, until Jetbrains can integrate it.

## Easy Coding Standard (ECS)

The easiest way to start using PHP CS Fixer and PHP_CodeSniffer with 0-knowledge

* [symplify/easy-coding-standard](https://github.com/Symplify/EasyCodingStandard)

### Installation of ECS using Composer

```sh
composer require symplify/easy-coding-standard --dev
```

### Example `ecs.yaml` file

```yaml
parameters:
    sets:
        - 'psr12'
        - 'php70'
        - 'php71'
        - 'symplify'
        - 'common'
        - 'clean-code'

    line_ending: "\n"

    # 4 spaces
    indentation: "    "

    skip:
        Symplify\CodingStandard\Sniffs\Architecture\DuplicatedClassShortNameSniff: null
        # Allow snake_case for tests
        PHP_CodeSniffer\Standards\Generic\Sniffs\NamingConventions\CamelCapsFunctionNameSniff:
            - tests/**
        # Ignore what is not owned - Laravel's TestCase class does not start with 'Abstract'
        Symplify\CodingStandard\Sniffs\Naming\AbstractClassNameSniff:
           - tests/TestCase.php
        # Ignore what is not owned - Laravel's traits do not end with 'Trait'
        Symplify\CodingStandard\Sniffs\Naming\TraitNameSniff:
            - tests/**
        # Ignore what is not owned - CommentedOutCodeSniff
        Symplify\CodingStandard\Sniffs\Debug\CommentedOutCodeSniff.Found:
            - app/Console/Kernel.php
        # Ignore what is not owned - @return \Illuminate\Contracts\Validation\Validator
        SlevomatCodingStandard\Sniffs\Namespaces\ReferenceUsedNamesOnlySniff.ReferenceViaFullyQualifiedName:
          - app/Http/Controllers/Auth/RegisterController.php

services:
    Symplify\CodingStandard\Sniffs\CleanCode\CognitiveComplexitySniff:
        max_cognitive_complexity: 8
```

Working example from [KnpLabs/DoctrineBehaviors](https://github.com/KnpLabs/DoctrineBehaviors)

Example **ecs.yaml**

```yaml
parameters:
    sets:
        - 'psr12'
        - 'php70'
        - 'php71'
        - 'symplify'
        - 'common'
        - 'clean-code'

    skip:
        PhpCsFixer\Fixer\Operator\UnaryOperatorSpacesFixer: null
        Symplify\CodingStandard\Sniffs\ControlStructure\SprintfOverContactSniff: null
        Symplify\CodingStandard\Sniffs\CleanCode\ForbiddenStaticFunctionSniff: null
        Symplify\CodingStandard\Sniffs\CleanCode\CognitiveComplexitySniff: null
        Symplify\CodingStandard\Sniffs\CleanCode\ForbiddenReferenceSniff: null
        Symplify\CodingStandard\Sniffs\Architecture\ExplicitExceptionSniff: null
        Symplify\CodingStandard\Sniffs\Architecture\DuplicatedClassShortNameSniff: null

        # mixed types
        SlevomatCodingStandard\Sniffs\TypeHints\PropertyTypeHintSniff: null

        # buggy
        Symplify\CodingStandard\Fixer\ControlStructure\PregDelimiterFixer: null

        PhpCsFixer\Fixer\PhpUnit\PhpUnitStrictFixer:
            - "tests/ORM/TimestampableTest.php"

        # weird naming
        Symplify\CodingStandard\Fixer\Naming\PropertyNameMatchingTypeFixer:
            - "src/Model/Geocodable/GeocodablePropertiesTrait.php"
            # & bug
            - "*Repository.php"

        SlevomatCodingStandard\Sniffs\Classes\UnusedPrivateElementsSniff:
            - "tests/Fixtures/Entity/SluggableWithoutRegenerateEntity.php"

services:
    Symplify\CodingStandard\Sniffs\CleanCode\CognitiveComplexitySniff:
        max_cognitive_complexity: 8

    PhpCsFixer\Fixer\ClassNotation\FinalClassFixer: ~

    # see single LICENSE.txt file in the root directory
    PhpCsFixer\Fixer\Comment\HeaderCommentFixer:
        header: ''

    PhpCsFixer\Fixer\Phpdoc\GeneralPhpdocAnnotationRemoveFixer:
        annotations:
            - 'author'
            - 'package'
            - 'license'
            - 'link'
            - 'abstract'

    # every property should have @var annotation
    # SlevomatCodingStandard\Sniffs\TypeHints\PropertyTypeHintSniff: ~
```

Example from **phpdocumentor\reflection-common\easy-coding-standard.neon**

```yaml
includes:
    - temp/ecs/config/clean-code.neon
    - temp/ecs/config/psr2.neon
    - temp/ecs/config/common.neon

parameters:
    exclude_checkers:
        # from temp/ecs/config/common.neon
        - PhpCsFixer\Fixer\ClassNotation\OrderedClassElementsFixer
        - PhpCsFixer\Fixer\PhpUnit\PhpUnitStrictFixer
        - PhpCsFixer\Fixer\ControlStructure\YodaStyleFixer
        # from temp/ecs/config/spaces.neon
        - PhpCsFixer\Fixer\Operator\NotOperatorWithSuccessorSpaceFixer

    skip:
        PHP_CodeSniffer\Standards\Generic\Sniffs\NamingConventions\CamelCapsFunctionNameSniff:
            - tests/**
```

### PHPStorm setup for Easy Coding Standard (ECS)

EasyCodingStandard can be used as an External Tool

Go to `Preferences` > `Tools` > `External Tools` and click `+` to add a new tool.

* Name: `ecs` (Can be any value)
* Description: `easyCodingStandard` (Can be any value)
* Program: `$ProjectFileDir$/vendor/bin/ecs` (Path to `ecs` executable; On Windows path separators must be a `\`)
* Parameters: `check $FilePathRelativeToProjectRoot$` (append `--fix` to auto-fix)
* Working directory: `$ProjectFileDir$`

Press `Cmd/Ctrl` + `Shift` + `A` (Find Action), search for `ecs`, and then hit Enter. It will run `ecs` for the current file.

To run `ecs` on a directory, right click on a folder in the project browser go to external tools and select `ecs`.

You can also create a keyboard shortcut in [Preferences > Keymap](https://www.jetbrains.com/help/webstorm/configuring-keyboard-and-mouse-shortcuts.html) to run `ecs`.

## PHP CodeSniffer

PHP_CodeSniffer tokenizes PHP, JavaScript and CSS files and detects violations of a defined set of coding standards.

* [squizlabs/php_codesniffer](https://github.com/squizlabs/PHP_CodeSniffer)

### Installation of PHP CodeSniffer using Composer

```sh
composer require squizlabs/php_codesniffer --dev
```

### Example `phpcs.xml.dist`

Example from **phpdocumentor\type-resolver**

Example **phpcs.xml.dist**

```xml
<?xml version="1.0"?>
<ruleset name="phpDocumentor">
 <description>The coding standard for phpDocumentor.</description>

    <file>src</file>
    <file>tests/unit</file>
    <exclude-pattern>*/tests/unit/Types/ContextFactoryTest.php</exclude-pattern>
    <arg value="p"/>
    <rule ref="PSR2">
        <include-pattern>*\.php</include-pattern>
    </rule>

    <rule ref="Doctrine">
        <exclude name="SlevomatCodingStandard.TypeHints.UselessConstantTypeHint.UselessDocComment" />
    </rule>

    <rule ref="Squiz.Classes.ValidClassName.NotCamelCaps">
        <exclude-pattern>*/src/*_.php</exclude-pattern>
    </rule>

    <rule ref="SlevomatCodingStandard.Classes.SuperfluousAbstractClassNaming.SuperfluousPrefix">
        <exclude-pattern>*/src/*/Abstract*.php</exclude-pattern>
    </rule>

    <rule ref="Generic.Formatting.SpaceAfterNot">
        <properties>
            <property name="spacing" value="0" />
        </properties>
    </rule>
</ruleset>
```

## PHPUnit

The PHP Unit Testing framework.

* [phpunit/phpunit](https://phpunit.de/getting-started/phpunit-8.html)

### Installation of PHPUnit using Composer

```sh
composer require phpunit/phpunit --dev
```

### Example `phpunit.xml` or `phpunit.xml.dist`

Example **phpunit.xml.dist** from [Laravel Package Boilerplate](https://laravelpackageboilerplate.com), very useful for
 coverage reports!


```xml
<?xml version="1.0" encoding="UTF-8"?>
<phpunit bootstrap="vendor/autoload.php"
         backupGlobals="false"
         backupStaticAttributes="false"
         colors="true"
         verbose="true"
         convertErrorsToExceptions="true"
         convertNoticesToExceptions="true"
         convertWarningsToExceptions="true"
         processIsolation="false"
         stopOnFailure="false">
    <testsuites>
        <testsuite name="Test Suite">
            <directory>tests</directory>
        </testsuite>
    </testsuites>
    <filter>
        <whitelist>
            <directory suffix=".php">src/</directory>
        </whitelist>
    </filter>
    <logging>
        <log type="tap" target="build/report.tap"/>
        <log type="junit" target="build/report.junit.xml"/>
        <log type="coverage-html" target="build/coverage" lowUpperBound="35" highLowerBound="70"/>
        <log type="coverage-text" target="build/coverage.txt"/>
        <log type="coverage-clover" target="build/logs/clover.xml"/>
    </logging>
</phpunit>
```

- Add `/build/` to **.gitignore**

```shell script
echo /build/ >> .gitignore
```

Example **phpunit.xml** from **livewire\livewire**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<phpunit backupGlobals="false"
         backupStaticAttributes="false"
         bootstrap="vendor/autoload.php"
         colors="true"
         convertErrorsToExceptions="true"
         convertNoticesToExceptions="true"
         convertWarningsToExceptions="true"
         processIsolation="false"
         stopOnFailure="false">
    <testsuites>
        <testsuite name="Unit">
            <directory suffix="Test.php">./tests</directory>
        </testsuite>
    </testsuites>
    <filter>
        <whitelist processUncoveredFilesFromWhitelist="true">
            <directory suffix=".php">./src</directory>
        </whitelist>
    </filter>
</phpunit>
```

**phpunit.xml** from KnpLabs/DoctrineBehaviors (minimalist)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<phpunit
     colors="true"
     bootstrap="tests/bootstrap.php"
>

    <testsuites>
        <testsuite name="Knp Doctrine2 Behaviors">
            <directory>tests</directory>
        </testsuite>
    </testsuites>
</phpunit>
```

## PHP Mess Detector

* [phpmd.org](https://phpmd.org/)

### Installation of PHP Mess Detector

Follow the link from [phpmd.org](https://phpmd.org/) to download the latest version and save the `phpmd.phar` file in an accessible location.

### Example `phpmd.xml`

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<ruleset
    name="ProxyManager rules"
    xmlns="http://pmd.sf.net/ruleset/1.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://pmd.sf.net/ruleset/1.0.0 http://pmd.sf.net/ruleset_xml_schema.xsd"
    xsi:noNamespaceSchemaLocation="http://pmd.sf.net/ruleset_xml_schema.xsd"
>
    <rule ref="rulesets/codesize.xml"/>
    <rule ref="rulesets/unusedcode.xml"/>
    <rule ref="rulesets/design.xml">
        <!-- eval is needed to generate runtime classes -->
        <exclude name="EvalExpression"/>
    </rule>
    <rule ref="rulesets/naming.xml">
        <exclude name="LongVariable"/>
    </rule>
    <rule ref="rulesets/naming.xml/LongVariable">
        <properties>
            <property name="minimum">40</property>
        </properties>
    </rule>
</ruleset>
```

Mess detection rules from **nesbot\Carbon**

Example `phpmd.xml`

```xml
<?xml version="1.0"?>
<ruleset name="Mess detection rules for Carbon"
         xmlns="http://pmd.sf.net/ruleset/1.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://pmd.sf.net/ruleset/1.0.0
                     http://pmd.sf.net/ruleset_xml_schema.xsd"
         xsi:noNamespaceSchemaLocation="
                     http://pmd.sf.net/ruleset_xml_schema.xsd">
    <description>
        Mess detection rules for Carbon
    </description>
    <rule ref="rulesets/codesize.xml">
        <exclude name="CyclomaticComplexity" />
        <exclude name="NPathComplexity" />
        <exclude name="ExcessiveMethodLength" />
        <exclude name="ExcessiveClassLength" />
        <exclude name="ExcessivePublicCount" />
        <exclude name="TooManyMethods" />
        <exclude name="TooManyPublicMethods" />
        <exclude name="ExcessiveClassComplexity" />
    </rule>
    <rule ref="rulesets/cleancode.xml">
        <exclude name="BooleanArgumentFlag" />
        <exclude name="StaticAccess" />
        <exclude name="IfStatementAssignment" />
    </rule>
    <rule ref="rulesets/controversial.xml" />
    <rule ref="rulesets/design.xml">
        <exclude name="EvalExpression" />
        <exclude name="CouplingBetweenObjects" />
        <exclude name="CountInLoopExpression" />
    </rule>
    <rule ref="rulesets/design.xml/CouplingBetweenObjects">
        <properties>
            <property name="maximum" value="20" />
        </properties>
    </rule>
    <rule ref="rulesets/naming.xml/ShortVariable">
        <properties>
            <property name="exceptions" value="ci,id,to,tz" />
        </properties>
    </rule>
    <rule ref="rulesets/unusedcode.xml" />
</ruleset>
```

## PHPStorm setup for PHP Mess Detector

* <https://www.jetbrains.com/help/phpstorm/using-php-mess-detector.html>

### Configure a local PHP Mess Detector script

1\) Download and install the PHP Mess Detector scripts.

To check the PHP Mess Detector installation, switch to the installation directory and run the following command:

`phpmd --version`

If the tool is available, you will get a message in the following format:

`PHPMD version <version>`

To have code checked against your own custom coding standard, create it. Store the rules and the ruleset.xml file that points to them in the rulesets root directory.

2\) Register the local PHP Mess Detector script in PhpStorm:

a. In the **Settings/Preferences** dialog Ctrl+Alt+S, navigate to **Languages & Frameworks | PHP | Quality Tools**.

b. On the Quality Tools page that opens, expand the **Mess Detector** area and click the Browse button next to the **Configuration** list.

c. In the **PHP Mess Detector** dialog that opens, specify the location of the `phpmd.bat` or `phpmd` PHP Mess Detector executable in the **PHP Mess Detector path** field. Type the path manually or click the Browse button and select the relevant folder in the dialog that opens.

To check that the specified path to `phpmd.bat` or `phpmd` ensures interaction between PhpStorm and PHP Mess Detector, that is, the tool can be launched from PhpStorm and PhpStorm will receive problem reports from it, click the **Validate** button. This validation is equal to running the `phpmd --version` command. If validation passes successfully, PhpStorm displays the information on the detected PHP Mess Detector version.

### Configure a PHP Mess Detector script associated with a PHP interpreter

1. In the **Settings/Preferences** dialog Ctrl+Alt+S, navigate to **Languages & Frameworks | PHP | Quality Tools**.

2. On the Quality Tools page that opens, expand the **Mess Detector** area and click the ... (Browse button) next to the **Configuration** list. **The PHP Mess Detector** dialog opens showing the list of all the configured PHP Mess Detector scripts in the left-hand pane, one of them is of the type ***Local*** and others are named after the PHP interpreters with which the scripts are associated. Click the Add button on the toolbar.

3. In the **PHP Mess Detector by Remote Interpreter** dialog that opens, choose the remote PHP interpreter to use the associated script from. If the list does not contain a relevant interpreter, click the Browse button and configure a remote interpreter in the **CLI Interpreters** dialog as described in Configuring Remote PHP Interpreters.

When you click **OK**, PhpStorm brings you back to the **PHP Mess Detector** dialog where the new ***PHP Mess Detector*** configuration is added to the list and the right-hand pane shows the chosen remote PHP interpreter, the path to the PHP Mess Detector associated with it, and the advanced PHP Mess Detector options.

## psalm

* [vimeo/psalm](https://github.com/vimeo/psalm)

A static analysis tool for finding errors in PHP applications <https://psalm.dev>

### Install psalm

Install via Composer:

```bash
composer require --dev vimeo/psalm
```

Add a config:

```bash
./vendor/bin/psalm --init
```

Then run Psalm:

```bash
./vendor/bin/psalm
```

### Example `psalm.xml`

```xml
<?xml version="1.0"?>
<psalm
    autoloader="psalm-autoload.php"
    stopOnFirstError="false"
    useDocblockTypes="true"
>
    <projectFiles>
        <directory name="app" />
        <directory name="tests" />
    </projectFiles>
    <issueHandlers>
        <RedundantConditionGivenDocblockType errorLevel="info" />
        <UnresolvableInclude errorLevel="info" />
        <DuplicateClass errorLevel="info" />
        <InvalidOperand errorLevel="info" />
        <UndefinedConstant errorLevel="info" />
        <MissingReturnType errorLevel="info" />
        <InvalidReturnType errorLevel="info" />
    </issueHandlers>
</psalm>
```

## Rector

Instant Upgrades and Instant Refactoring of any PHP 5.3+ code <https://getrector.org>

* [rectorphp/rector](https://github.com/rectorphp/rector)

### Installation of Rector using Composer

```sh
composer require rector/rector --dev
```

### Example `rector.yaml`

```yaml
parameters:
    sets:
        - 'code-quality'
        - 'php71'
        - 'php72'
        - 'php73'

    php_version_features: '7.2' # your version is 7.3

    paths:
        - 'src'
        - 'tests'
```

### Demo

```bash
git clone <forked> https://github.com/rectorphp/demo.git
cd demo
composer install
```

```yaml
parameters:
    php_version_features: '7.2'

# demo
# 1. php
# vendor/bin/rector process src/PhpCodeUpgrade/CountOnNullableAndArrayAssign.php --set php71 --dry-run
# vendor/bin/rector process src/PhpCodeUpgrade/CreateFunction.php --set php72 --dry-run

# 2. code quality
# vendor/bin/rector process src/CodeQuality --set code-quality --dry-run
# vendor/bin/rector process src/PhpCodeUpgrade --set type-declaration --dry-run

# 3. twig
# vendor/bin/rector process src --set twig-underscore-to-namespace --dry-run

# 4. phpunit
# vendor/bin/rector process src tests --set phpunit70 --dry-run

# typed properties - @todo change param to the PHP 7.4
# not only improve, but also fix BC breaks
# vendor/bin/rector process src --set php74 --dry-run

# list all available sets:
# vendor\bin\rector sets
```

### Example rector-ci.yaml

```yaml
parameters:
    paths:
        - "src"
        - "tests"

    sets:
        - 'dead-code'
        - 'code-quality'
        - 'coding-style'
        - 'nette-utils-code-quality'

    exclude_rectors:
        - 'Rector\DeadCode\Rector\Class_\RemoveUnusedDoctrineEntityMethodAndPropertyRector'
        - 'Rector\SOLID\Rector\ClassMethod\UseInterfaceOverImplementationInConstructorRector'

    exclude_paths:
        - 'src/Model/Translatable/TranslatableMethodsTrait.php'
```

Example **rector-ci.yaml** from symplify / symplify

```yaml
services:
    Rector\SOLID\Rector\Property\ChangeReadOnlyPropertyWithDefaultValueToConstantRector: null
    Rector\SOLID\Rector\ClassMethod\ChangeReadOnlyVariableWithDefaultValueToConstantRector: null

parameters:
    auto_import_names: true
    autoload_paths:
        - 'tests/bootstrap.php'

    sets:
        - 'code-quality'
        - 'dead-code'
        - 'coding-style'
        - 'php-70'
        - 'php-71'
        - 'php-72'

    paths:
        - "packages"

    exclude_paths:
        - '/vendor/'
        - '/init/'
        - '/Source/'
        - '/ChangedFilesDetectorSource/'
        # parameter Symfony autowire hack
        - 'packages/changelog-linker/src/DependencyInjection/Dummy/ResolveAutowiringExceptionHelper.php'
        - 'packages/monorepo-builder/packages/init/templates/*'

    exclude_rectors:
        # too free
        - 'Rector\SOLID\Rector\ClassMethod\UseInterfaceOverImplementationInConstructorRector'
        # needs to skip dev classes
        - 'Rector\Php55\Rector\String_\StringClassNameToClassConstantRector'
        # this should skip preg_match etc. patterns
        - 'Rector\CodingStyle\Rector\String_\SymplifyQuoteEscapeRector'
        # buggy
        - 'Rector\CodingStyle\Rector\Use_\RemoveUnusedAliasRector'

        # many edge cases on known array key contents
        - 'Rector\Php71\Rector\FuncCall\CountOnNullRector'

        # fixed in master
        - 'Rector\Php70\Rector\MethodCall\ThisCallOnStaticMethodToStaticCallRector'
```

## Phan

Phan is a static analyzer for PHP. Phan prefers to avoid false-positives and attempts to prove incorrectness rather than
 correctness. <https://github.com/phan/phan/wiki>
 
* [phan/phan](https://github.com/phan/phan)

```shell script
composer require phan/phan
```
