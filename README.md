# Symfony 5.2 Skeleton Project

Symfony 5.2 Skeleton Project with Docker, PHP 7.4, Nginx, Varnish, HAProxy, MariaDB 10.5.6, MongoDB 4.2,
Redis 5.0, PhpMyAdmin, Mongo Express, Portainer and Mailhog mailserver.

For the frontend part [Bulma.io](https://bulma.io) CSS framework and [Vue.js](https://vuejs.org) is used.

## Prerequisites

The preferred OS for development is Linux or MacOS with installed Docker as development system.
You can also use Virtualbox and Vagrant. Then you must have Virtualbox >= 5.2 and Vagrant installed on your
development machine.

If you're working on Windows you must use the Virtualbox / Vagrant variant.

The following software products are needed for the Docker variant:

+ [Docker](https://docker.com) with Docker Compose (on MacOS use Docker Desktop
  [2.1.0.5](https://download.docker.com/mac/stable/40693/Docker.dmg), later versions
  actually have problems with mapping of IPs other than localhost to Docker containers)
+ [Bash](https://www.gnu.org/software/bash/) Shell

Not really needed, but recommended:

+ [PHP](https://php.net) 8.0 with Intl, MySQL, XDebug and MongoDB extensions
+ [Symfony CLI](https://symfony.com/download)
+ [Node.js](https://nodejs.org) and [Yarn](https://yarnpkg.com) package manager
+ [PHPStorm](https://www.jetbrains.com/phpstorm/) integrated development environment

And for the Virtualbox / Vagrant variant you need the following:

+ [Virtualbox](https://virtualbox.org) recommended version: 6.1+
+ [Vagrant](https://www.vagrantup.com) recommended version: 2.2.14+

You also need the following plugins for Vagrant

+ Vagrant VBGuest
+ Vagrant Env
+ Vagrant Hostsupdater

You can install the plugins with the following commands:

    vagrant plugin install vagrant-vbguest
    vagrant plugin install vagrant-env
    vagrant plugin install vagrant-hostsupdater

On Windows, you must change the ACL of the `hosts` file, so Vagrant can update it. Run the
following command as Administrator:

    cacls %SYSTEMROOT%\system32\drivers\etc\hosts /E /G %USERNAME%:W

Windows users must also install the Winnfsd plugin for using the NFS protocol for
sharing data between the Virtualbox VM and Windows:

    vagrant plugin install vagrant-winnfsd

## Building the development system with Docker

The development system is build in two steps, first build the local Docker images and
start the Docker stack. And second, build the Symfony application inside the Docker
stack.

### Initial build Docker images and start Docker stack

All Docker and build functions are managed by the `docker.sh` script in the project
root directory.

1.) To build all local Docker images and start the whole Docker stack, execute the following
command:

     ./docker.sh start

After the command has finished, you should see a message like

    --------------------------------------------------------------------------------
    Available services from Docker stack
    --------------------------------------------------------------------------------
    Application.....: http://symfony.local
    Varnish.........: http://symfony.local:8080
    Nginx...........: http://symfony.local:8081
    PhpMyAdmin......: http://symfony.local:8082
    Mongo Express...: http://symfony.local:8083
    Portainer.......: http://symfony.local:8084
    Mailhog.........: http://symfony.local:8085
    --------------------------------------------------------------------------------

All HTTP requests are served by the HAProxy loadbalancer listening on port 80. The HAProxy uses the Varnish
proxy as backend server. Varnish uses the Nginx webserver with the PHP-FPM backend.

You can also use Varnish and Nginx directly for testing and debugging.

2.) The Symfony application with database, data fixtures and frontend is build with the following command:

     ./docker.sh phing rebuild      # production build
     ./docker.sh phing rebuild-dev  # development build

You should only use `./docker.sh phing rebuild` or `./docker.sh phing rebuild-dev` to rebuild the whole application with a fresh database and fixtures.
After rebuild the MariaDB and MongoDB databases are found in the folder `docker-data`.

You can stop the Docker stack with

    ./docker.sh stop

and start it again later with

    ./docker.sh start

### Useful commands to work with the Docker stack

#### Show status of the Docker stack

Show status of the Docker stack and running services.

    ./docker.sh status

#### Execute command in the PHP container

For example to use the Symfony console. The starting path is the application directory.

    ./docker.sh exec php bin/console ...      

#### Start shell

The interactive shell is started in the PHP container.

    ./docker.sh shell

#### Execute Phing target

Phing targets can be executed by the following command:

    ./docker.sh phing <target>

The following Phing targets are defined, see target definitions in `phing/` directory:

| Target | Description |
| ------ | :---------- |
| build         | Build for production |
| build-dev     | Build for development |
| rebuild       | Rebuild for production with database and fixtures |
| rebuild-dev   | Rebuild for development with database and fixtures |
| composer:check-dependencies | Check Composer dependencies without install |
| composer:install | Install composer dependencies |
| composer:update | Update composer dependencies |
| doctrine:database:create | Create MariaDB database |
| doctrine:database:drop | Drop MariaDB database |
| doctrine:database:migrate | Migrate MariaDB database |
| doctrine:database:purge | Drop, create and migrate MariaDB database |
| doctrine:fixtures | Load fixtures |
| frontend:build | Build frontend for production |
| frontend:build-dev | Build frontend for development |
| quality:lint-php | Perform syntax check of PHP sourcecode files |
| quality:pdepend | Calculate software metrics using PHP Depend |
| quality:phpcpd | Find duplicate PHP code using PHPCPD |
| quality:phpcs | Find PHP PSR-2 coding standard violations using PHP CodeSniffer |
| quality:phploc | Measure project size using PHPLOC |
| quality:phpmd | Perform PHP mess detection using PHPMD |
| quality:phpmetrics | Provides metrics about PHP project and classes |
| symfony:cache-clear | Clear all Symfony caches |
| test:phpunit | Run PHPUnit tests |
| test:coverage | Run PHPUnit tests with code coverage report |

## Building the development system with Virtualbox / Vagrant

The development system is build in two steps, first start the virtual machine, build the
local Docker images and start the Docker stack inside the virtual machine.
And second, build the Symfony application inside the Docker stack in the virtual machine.

### Start virtual machine, build Docker images and start Docker stack

Execute `vagrant up` in the project root directory. This will build the virtual machine and
build the whole docker stack and fire it up.

After this is step is done you should see a message like

    --------------------------------------------------------------------------------
    Available services
    --------------------------------------------------------------------------------
    Application.....: http://symfony.local
    Varnish.........: http://symfony.local:8080
    Nginx...........: http://symfony.local:8081
    PhpMyAdmin......: http://symfony.local:8082
    Mongo Express...: http://symfony.local:8083
    Portainer.......: http://symfony.local:8084
    Mailhog.........: http://symfony.local:8085
    --------------------------------------------------------------------------------

Now you can log into the virtual machine: `vagrant ssh`. You can step into the project
directory `/app` and execute the build script or other commands.

    vagrant@symfony:~$ cd /app

All build functions are managed by the `build.sh` script in the project root directory.

1.) The Symfony application with database, data fixtures and frontend is build with the following command:

     ./build.sh phing rebuild      # production build
     ./build.sh phing rebuild-dev  # development build


You should only use `./build.sh rebuild` or `./build.sh rebuild-dev` to rebuild the whole application with a fresh database and fixtures.
After rebuild the MariaDB and MongoDB databases are found in the folder `/data`.

### Useful commands for the Docker stack inside the virtual machine

#### Show status of the Docker stack

Show status of the Docker stack and running services.

    ./build.sh status

#### Execute command in the PHP container

For example to use the Symfony console. The starting path is the application directory.

    ./build.sh exec php bin/console ...      

#### Start shell

The interactive shell is started in the PHP container.

    ./build.sh shell

#### Execute Phing target

Phing targets can be executed by the following command:

    ./build.sh phing <target>

## Development and management tools

There are some development and management tools available on the Docker stack.

### PhpMyAdmin

[PhpMyAdmin](https://phpmyadmin.net) is a free software tool written in PHP, intended
to handle the administration of MySQL over the Web. PhpMyAdmin supports a wide range
of operations on MySQL and MariaDB. Frequently used operations (managing databases,
tables, columns, relations, indexes, users, permissions, etc) can be performed via
the user interface, while you still have the ability to directly execute any SQL
statement.

You can access it at [http://symfony.local:8081](http://symfony.local:8081).

### Mongo Express

[Mongo Express](https://github.com/mongo-express/mongo-express) is a web-based
MongoDB admin interface written with Node.js, Express and Bootstrap3.

You can access it at [http://symfony.local:8082](http://symfony.local:8082).

### Portainer

[Portainer](https://portainer.io) Community Edition (Portainer CE) is a lightweight
management toolset that allows you to easily build, manage and maintain Docker
environments.

You can access it at [http://symfony.local:8083](http://symfony.local:8083).

### Mailhog

[Mailhog](https://github.com/mailhog/MailHog) is an email testing tool for developers.
Configure your application to use MailHog for SMTP delivery, view messages in the web UI, or retrieve them with the JSON API.
Optionally release messages to real SMTP servers for delivery.
