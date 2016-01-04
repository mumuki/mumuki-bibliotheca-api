[![Build Status](https://travis-ci.org/mumuki/mumuki-bibliotheca.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-bibliotheca)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-bibliotheca/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-bibliotheca)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-bibliotheca/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-bibliotheca)

# Mumuki Bibliotheca
> Storage and formatting service for guides

## About

Bibliotheca is a service for storing Mumuki guides. Its main persistent media is MongoDB, but it is also capable of importing and exporting guides from a Github repository. Features:

* REST API
* Importing and exporting to a Github repository
* Listing and upserting guides in JSON format
* Pemissions validation
* Optional changes notifications to Aheneum

## Getting started

* Installing

```bash
bundle install
```

* Running tests:

```bash
bundle exec rspec
```

* Starting the server

```bash
MUMUKI_BIBLIOTHECA_CLIENT_ID=... MUMUKI_BIBLIOTHECA_CLIENT_SECRET=... bundle exec rackup 
```

## Authentication Powered by Auth0 

<a width="150" height="50" href="https://auth0.com/" target="_blank" alt="Single Sign On & Token Based Authentication - Auth0"><img width="150" height="50" alt="JWT Auth for open source projects" src="http://cdn.auth0.com/oss/badges/a0-badge-dark.png"/></a>
