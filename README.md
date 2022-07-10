# swgemu-docker
```
A Docker image and docker-compose file setup for running an SWGEmu dev environment **database** in Docker.
```

## Overview
This repo contains a Dockerfile, docker-compose.yml, and other supporting files to run the [SWGEmu](https://www.swgemu.com/) database in a Docker container. It is loosely based off of the work on [ZonamaDev VM](https://github.com/Zonama/ZonamaDev).

This contains a sql stub locally, for MySQL bootstrap scripts,  in order to facilicate both an eventual path to creating production images that could be used to host SWGEmu servers where DB and gameserver isolation is required - unlike the master branch of this same project.

### Features

* A Dockerfile to build an image that will run the SWGEmu Core3 database - with an easily accesible bootstrap/init script location.
* A docker-compose file for an easy start of MySQL
* Pre-created admin account
* Additional items/professions enabled on the BlueFrog terminals for testing

## Getting Started

### Prerequisites

* Install Docker (CE) and Docker Compose - https://docs.docker.com/v17.09/engine/installation/


### Building the Image

The image can be built using `docker-compose` or manually using `Docker`.

docker-compose:
```$bash
$ docker-compose build
```

Manually using Docker:
```$bash
$ docker build . -t database:dev
```

### Starting the Database

The docker-compose file can be used to run a fresh server out of the box:

```$bash
$ docker-compose up [-d]
```

On the first run, this will start a MySQL container and create the SWGEmu database from scratch using the [swgemu.sql](sql/swgemu.sql) script to create the schema.

**Note: This swgemu.sql script should ber periodically refreshed from either the upstream source [Core3](https://github.com/swgemu/Core3/tree/unstable/MMOCoreORB/sql), this projects' master branch [thmhoag/swgemu-docker](https://github.com/thmhoag/swgemu-docker/tree/master/sql), or from a database export that you are working with [ie. mysqldump](https://dev.mysql.com/doc/workbench/en/wb-admin-export-import-management.html). 


### Configuring the Database
Once running, you should connect to the MySQL database via port 3306 and the credentials configured in your docker-compose.yml. 
Update the "swgemu.galaxy" table to reflect the host IP of your **game server** - and then login with the default credentials noted in the next section.

#### Resetting the Database
Should you wish to "wipe" the database, without being connected, simply remove all contents from the /mysql directory (**EXCEPT THE .gitkeep FILE**), and then re-run docker-compose up.

### Logging into the Server

Using the SWGEmu Launchpad, make sure that the server selected is `local` prior to launching the game. Whem prompted for credentials, use the following:

```
user: admin
pass: admin
```

This user account is setup by the [admin_account.sql](sql/02-admin_account.sql) and will have full admin privileges. Additional user accounts can be setup simply by logging in with a new user/pass combination. These accounts will not have full admin rights.


## Server Management

### Connecting to the MySQL Database

You can connect to the MySQL database using `localhost:3306` using any MySQL compatible tool. The root password can be found in the [docker-compose.yml](docker-compose.yml)

### In-game Commands

All admin commands will be available to the default admin/admin account. You can find a full list of SWGAdmin commands here: [CommandsV2](https://drive.google.com/file/d/0BwjBDOFpOsM5OEVuMDh1U3BDYnM/view)

