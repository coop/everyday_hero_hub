# Everyday Hero Hub

At a glance, understand the state of the world.

## Dependences

* Ruby 2
* Rails 4
* PostgreSQL 9.2

### Development (Optional)

* foreman >= 0.63.0
* pow

## Setup

This script will copy configuration files, setup the database and run
the specs.

    $ bin/bootstrap

Seeding GitHub with an endpoint to test can be achieved a rake task.

    $ bin/rake github:seed

## Processes

By default `foreman start` will load each entry in the Procfile. The
processes can be started individually if required.

### Web

Start the webserver in development. The website can be viewed at
http://everyday-hero-hub.dev.

    $ foreman start web

## Tests

Run the entire test suite.

    $ bin/rake

## Deploy

Heroku.

    $ git push heroku master
