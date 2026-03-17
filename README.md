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

### 1. Install essentials and base libraries
> First, we need to install some software: [PostgreSQL](https://www.postgresql.org) database, [RabbitMQ](https://www.rabbitmq.com/) queue, and some common Ruby on Rails native dependencies

```bash
sudo apt-get install autoconf curl git build-essential libssl-dev autoconf bison libreadline6 libreadline6-dev zlib1g zlib1g-dev postgresql libpq-dev rabbitmq-server
```

### 2. Install rbenv
> [rbenv](https://github.com/rbenv/rbenv) is a ruby versions manager, similar to rvm, nvm, and so on.

```bash
curl -fsSL https://raw.githubusercontent.com/rbenv/rbenv-installer/refs/heads/main/bin/rbenv-installer | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc # or .bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bashrc # or .bash_profile
```

### 3. Install ruby

> Now we have rbenv installed, we can install ruby and [bundler](http://bundler.io/)

```bash
rbenv install 2.6.3
rbenv global 2.6.3
rbenv rehash
gem install bundler -v 2.4.22 # Last compatible version with 2.6.3
```

### 4. Clone this repository

> Because, err... we need to clone this repostory before developing it :stuck_out_tongue:

```bash
git clone https://github.com/mumuki/mumuki-bibliotheca-api
cd mumuki-bibliotheca-api
```

### 5. Install and setup database

Install postgres:

```bash
# Linux
sudo apt install postgresql
```


> We need to create a PostgreSQL role - AKA a user - who will be used by Laboratory to create and access the database

```bash
# create db user for linux users
sudo -u postgres psql <<EOF
  create role mumuki with createdb login password 'mumuki';
EOF

# create db user for mac users
psql postgres
#once inside postgres server
create role mumuki with createdb login password 'mumuki';

# create schema and initial development data
./devinit
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

## TypeScript Guide Reader

A TypeScript library is included that can read a guide repository from a local directory or directly from GitHub and return its JSON representation.

### Installation

```bash
npm install
```

### Usage

```typescript
import { readGuideFromDir, readGuideFromGithub } from 'mumuki-guide-reader';

// From a local clone
const guide = await readGuideFromDir('./my-guide-repo', 'myorg/my-guide');

// From a public GitHub repository
const guide = await readGuideFromGithub('myorg/my-guide');

// From a private GitHub repository
const guide = await readGuideFromGithub('myorg/private-guide', { token: 'ghp_...' });

// Targeting a specific branch or tag
const guide = await readGuideFromGithub('myorg/my-guide', { ref: 'v2.0' });
```

### Guide repository structure

```
guide-repo/
├── meta.yml                      # Guide metadata (see fields below)
├── description.md                # Guide description (required)
├── expectations.yml              # Guide-level expectations (optional)
├── AUTHORS.txt                   # Author names → authors field (optional)
├── COLLABORATORS.txt             # Collaborator names (optional)
├── corollary.md                  # Closing remarks (optional)
├── extra.<ext>                   # Extra code shared across exercises (optional)
├── sources.md                    # Source citations (optional)
└── 1_exercise_name/              # Exercise directory: number → id, slug → name
    ├── meta.yml                  # Exercise metadata (see fields below)
    ├── description.md            # Exercise description (required)
    ├── test.<ext>                # Test code (optional)
    ├── extra.<ext>               # Exercise-specific extra code (optional)
    ├── default.<ext>             # Starter code for students → default_content (optional)
    ├── hint.md                   # Hint text (optional)
    ├── corollary.md              # Post-exercise remarks (optional)
    ├── expectations.yml          # Exercise-level expectations (optional)
    └── free_form_editor_source.html  # For free-form editor exercises (optional)
```

File extensions for code and test files are language-specific (e.g. `.hs` for Haskell, `.py` for Python). Files are discovered by stem name, so the extension does not need to be known in advance.

Exercise directories must follow the `<number>_<name>` pattern (e.g. `1_hello_world`, `02_variables`). The number becomes the exercise `id`; the name part becomes the default `name` and can be overridden in the exercise `meta.yml`.

#### Guide `meta.yml` fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `language` | string | yes | Programming language (e.g. `haskell`, `python`) |
| `name` | string | no | Guide title |
| `locale` | string | no | Locale code (e.g. `en`, `es`) |
| `type` | string | no | `practice` (default), `learning`, or `exam` |
| `beta` | boolean | no | Mark guide as beta (default: `false`) |
| `private` | boolean | no | Mark guide as private (default: `false`) |
| `id_format` | string | no | Exercise ID format string (e.g. `%05d`) |
| `order` | number[] | no | Explicit exercise ordering by id |
| `teacher_info` | string | no | Notes visible only to teachers |
| `settings` | object | no | Arbitrary key/value settings |
| `custom_expectations` | string | no | Custom expectation rules |

Legacy fields also supported: `learning: true` is equivalent to `type: learning`; `original_id_format` is used as `id_format` when `id_format` is absent.

#### Exercise `meta.yml` fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Override the name derived from the directory |
| `type` | string | `problem` (default), `playground`, or `reading` |
| `locale` | string | Locale code |
| `layout` | string | Editor layout (e.g. `input_bottom`, `input_right`) |
| `editor` | string/number | Editor type (e.g. `code`, `single_choice`, `multiple_choice`) |
| `language` | string | Override the guide language for this exercise |
| `tags` | string[] | Tags → `tag_list` in output |
| `extra_visible` | boolean | Whether extra code is visible to students (default: `false`) |
| `manual_evaluation` | boolean | Requires manual teacher evaluation (default: `false`) |
| `teacher_info` | string | Notes visible only to teachers |
| `assistance_rules` | object[] | Hint/assistance rules |
| `randomizations` | object | Random variation configuration |
| `choices` | object[] | Choices for single/multiple choice exercises |
| `progressive_expectations` | boolean | Enable progressive expectations (default: `false`) |
| `settings` | object | Arbitrary key/value settings |

### Running the TypeScript tests

```bash
npm test
```

### Building

```bash
npm run build
```

Output is written to `dist/`.

## See also

[Bibliotheca Web Client](https://github.com/mumuki/mumuki-bibliotheca)

## Authentication Powered by Auth0

<a width="150" height="50" href="https://auth0.com/" target="_blank" alt="Single Sign On & Token Based Authentication - Auth0"><img width="150" height="50" alt="JWT Auth for open source projects" src="http://cdn.auth0.com/oss/badges/a0-badge-dark.png"/></a>
