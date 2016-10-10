[![wercker status](https://app.wercker.com/status/0b4dd5fa93028f3a8172e685187d542a/s/master "wercker status")](https://app.wercker.com/project/bykey/0b4dd5fa93028f3a8172e685187d542a)

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
MUMUKI_ATHENEUM_URL=... \
MUMUKI_ATHENEUM_CLIENT_SECRET=... \
MUMUKI_ATHENEUM_CLIENT_ID=... \
MUMUKI_BOT_USERNAME=... \
MUMUKI_BOT_EMAIL=... \
MUMUKI_BOT_API_TOKEN=... \
MUMUKI_AUTH0_CLIENT_ID=... \
MUMUKI_AUTH0_CLIENT_SECRET=... \
bundle exec rackup
```

* Running tasks

```bash
# import guides from a github organization
bundle exec rake guides:import[<a github organization>]

# import languages from http://thesaurus.mumuki.io
bundle exec rake languages:import
```
## Authentication Powered by Auth0

<a width="150" height="50" href="https://auth0.com/" target="_blank" alt="Single Sign On & Token Based Authentication - Auth0"><img width="150" height="50" alt="JWT Auth for open source projects" src="http://cdn.auth0.com/oss/badges/a0-badge-dark.png"/></a>
