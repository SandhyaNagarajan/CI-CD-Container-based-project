# Insight DevOps Engineering Systems Puzzle

## Table of Contents

1. [Introduction](README.md#introduction)
2. [Additional notes](README.md#Aditional notes)
3. Testing jenkins webhook

# Introduction

Imagine you're on an engineering team that is building an eCommerce site where users can buy and sell items (similar to Etsy or eBay). One of the developers on your team has put together a very simple prototype for a system that writes and reads to a database. The developer is using Postgres for the backend database, the Python Flask framework as an application server, and nginx as a web server. All of this is developed with the Docker Engine, and put together with Docker Compose.


Assuming you have the Docker Engine and Docker Compose already installed, the developer said that the steps for running the system is to open a terminal, `cd` into this repo, and then enter these two commands:

    docker-compose up -d db
    docker-compose run --rm flaskapp /bin/bash -c "cd /opt/services/flaskapp/src && python -c  'import database; database.init_db()'"

This "bootstraps" the PostgreSQL database with the correct tables. After that you can run the whole system with:

    docker-compose up -d

At that point, the web application should be visible by going to `localhost:8080` in a web browser.

Once you've corrected the bugs and have the basic features working, commit the functional codebase to a new repo following the instructions below. As you debug the system, you should keep track of your thought process and what steps you took to solve the puzzle.

# Aditional notes

## How to debug the container
### In app.py:
 'app.config['DEBUG'] = True' to display each internal step and to auto detect
 change in the file and autoreload the app
### In database.py :
 add echo = True to get the log from the DB on the console
### while running docker-compose up:
 DO NOT use '-d'(demon mode) to see the log in the console

## How to clear all the containers and imagines to restart the whole application
run ./clearall.sh in the project root. clearall.sh is available in this github root.
clearall.sh:

 #!/bin/bash
docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
exit;

Now, run the run_from_scratch.sh to run all the commands needed to build the app(in debug mode.)
