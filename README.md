[![Build Status](https://travis-ci.org/mumuki/mumuki-bibliotheca-api.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-bibliotheca-api)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-bibliotheca-api/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-bibliotheca-api)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-bibliotheca-api/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-bibliotheca-api)
[![Issue Count](https://codeclimate.com/github/mumuki/mumuki-bibliotheca-api/badges/issue_count.svg)](https://codeclimate.com/github/mumuki/mumuki-bibliotheca-api)

# Mumuki Bibliotheca API
> Storage and formatting API for guides

## About

Bibliotheca is a service for storing Mumuki content - Books, Topics and Guides. Its main persistent media is MongoDB, but it is also capable of importing and exporting guides from a Github repository. Features:

* REST API
* Importing and exporting to a Github repository
* Listing and upserting guides in JSON format
* Pemissions validation
* Optional changes notifications to Aheneum

## Preparing environment

### TL;DR install

1. Install [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Run `curl https://raw.githubusercontent.com/mumuki/mumuki-devinstaller/master/install.sh | bash`
3. `cd mumuki && vagrant ssh` and then - **inside Vagrant VM** - `cd /vagrant/bibliotheca-api`
4. Go to step Install Section

### 1. Install essentials and base libraries

> First, we need to install some software: MongoDB and some common Ruby on Rails native dependencies

1. Follow [MongoDB installation guide](https://docs.mongodb.com/v3.2/tutorial/install-mongodb-on-ubuntu/)
2. Run:

```bash
sudo apt-get install autoconf curl git build-essential libssl-dev autoconf bison libreadline6 libreadline6-dev zlib1g zlib1g-dev
```

### 2. Install rbenv

> [rbenv](https://github.com/rbenv/rbenv) is a ruby versions manager, similar to rvm, nvm, and so on.

```bash
curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc # or .bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bashrc # or .bash_profile
```

### 3. Install ruby

> Now we have rbenv installed, we can install ruby and [bundler](http://bundler.io/)

```bash
rbenv install 2.3.1
rbenv global 2.3.1
rbenv rehash
gem install bundler
gem install escualo
```

### 4. Clone this repository

> Because, err... we need to clone this repostory before developing it :stuck_out_tongue:

```bash
git clone https://github.com/mumuki/mumuki-bibliotheca-api bibliotheca-api
cd bibliotheca-api
```

## Installing and Running

### Quick start

If you want to start the server quickly in developer environment,
you can just do the following:

```bash
./devstart
```

This will install your dependencies and boot the server.

### Installing the server

If you just want to install dependencies, just do:

```
bundle install
```

### Running the server

You can boot the server by using the standard rackup command:

```
# using defaults from config/puma.rb and rackup default port 9292
bundle exec rackup

# changing port
bundle exec rackup -p 8080

# changing threads count
MUMUKI_BIBLIOTHECA_API_THREADS=30 bundle exec rackup
```

Or you can also start it with `puma` command, which gives you more control:

```
# using defaults from config/puma.rb
bundle exec puma

# changing ports and threads count, using puma-specific options:
bundle exec puma -t 2:30 -p 8080

# changing ports and threads count, using environment variables:
MUMUKI_BIBLIOTHECA_API_PORT=8080 MUMUKI_BIBLIOTHECA_API_THREADS=30 bundle exec puma
```

## Running tests

```bash
bundle exec rspec
```

## Running tasks

```bash
# import guides from a github organization
bundle exec rake guides:import[<a github organization>]

# import languages from http://thesaurus.mumuki.io
bundle exec rake languages:import
```

## Running Migrations

```bash
# migration_name is the name of the migration file in ./migrations/, without extension and the "migrate_" prefix
bundle exec rake db:migrate[<migration_name>]
```

## See also

[Bibliotheca Web Client](https://github.com/mumuki/mumuki-bibliotheca)

## Authentication Powered by Auth0

<a width="150" height="50" href="https://auth0.com/" target="_blank" alt="Single Sign On & Token Based Authentication - Auth0"><img width="150" height="50" alt="JWT Auth for open source projects" src="http://cdn.auth0.com/oss/badges/a0-badge-dark.png"/></a>
