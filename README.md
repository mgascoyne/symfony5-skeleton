# Symfony 5 Skeleton Project

Symfony 5 Skeleton Project with Docker, PHP 7.4, Nginx, Varnish, MySQL 5.7, MongoDB 4.2,
PhpMyAdmin, Mongo Express and Portainer.

For the frontend part [Bulma.io](https://bulma.io) CSS framework and [Vue.js](https://vuejs.org) is used.

## Prerequisites

Developers should use Linux or MacOS as development system. Windows users could have
several problems. The Docker scripts only supports Linux and MacOS.

The following software products are needed:

+ [Docker](https://docker.com) with Docker Compose (on MacOS use Docker Desktop 
  [2.1.0.5](https://download.docker.com/mac/stable/40693/Docker.dmg), later versions
  actually have problems with mapping of IPs other than localhost to Docker containers)
+ [Bash](https://www.gnu.org/software/bash/) Shell

Not really needed, but recommended:

+ [PHP](https://php.net) 7.4 with Intl, MySQL, XDebug and MongoDB extensions
+ [Symfony CLI](https://symfony.com/download)
+ [Node.js](https://nodejs.org) and [Yarn](https://yarnpkg.com) package manager
+ [PHPStorm](https://www.jetbrains.com/phpstorm/) integrated development environment

## Building the development system

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
    Nginx...........: http://symfony.local:8080
    PhpMyAdmin......: http://symfony.local:8081
    Mongo Express...: http://symfony.local:8082
    Portainer.......: http://symfony.local:8083
    --------------------------------------------------------------------------------
 
2.) The Symfony application with database, data fixtures and frontend is build with the following command:

     ./docker.sh rebuild
    
You should only use `./docker.sh rebuild` to rebuild the whole application with a fresh database and fixtures.
After rebuild the MySQL and MongoDB databases are found in the folder `docker-data`.     

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

    ./docker.sh exec "php bin/console ..."      

#### Start shell

The interactive shell is started in the PHP container.

    ./docker.sh shell
    
#### Recreate the MySQL database
 
The database is recreated (use with caution!) without loading data fixtures.

    ./docker.sh recreatedb
    
#### Load data fixtures
 
The database is cleaned before loading the data fixtures, so use this command with
caution.

    ./docker.sh fixtures

#### Run database migrations

Database migrations are executed without deleting anything in the database.

    ./docker.sh migratedb
        
#### Build Symfony application and frontend
 
The Symfony application and the frontend are build and database migrations are executed
without cleaning anything from the database.

    ./docker.sh build

Do do a build with a creation of new database you must run

    ./docker.sh rebuild
    
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
