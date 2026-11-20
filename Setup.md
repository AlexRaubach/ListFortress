# Local Development Setup

This project runs on Ruby on Rails and targets Linux (via Heroku). The simplest way to develop on Windows is via WSL2, which is what this guide assumes.

## Prerequisites

### WSL2

Follow [Microsoft's instructions](https://learn.microsoft.com/en-us/windows/wsl/install) to install WSL2 with an Ubuntu LTS distro, then open a WSL terminal for all remaining steps.

### VS Code

Install [VS Code](https://code.visualstudio.com/) on Windows and the [WSL extension](https://code.visualstudio.com/docs/remote/wsl). Run `code .` from the project root to open VS Code connected to WSL.

### Clone the repo

```bash
git clone https://github.com/AlexRaubach/ListFortress.git
cd ListFortress
```

### Node.js

Install Node 26 (pinned in `package.json` under `engines`) via [nvm](https://github.com/nvm-sh/nvm) or your distro's package manager. Node is required for the asset pipeline.

### rbenv + Ruby

Install rbenv and ruby-build using the [rbenv installer script](https://github.com/rbenv/rbenv-installer#rbenv-installer), then install the project's Ruby version (see `.ruby-version`):

```bash
rbenv install $(cat .ruby-version)
rbenv rehash
```

Install Bundler:

```bash
gem install bundler
```

### PostgreSQL

Install PostgreSQL via your distro's package manager and ensure it's running:

```bash
sudo apt install postgresql
sudo service postgresql start
```

Create a superuser role for Rails (substitute your preferred username/password):

```bash
sudo -u postgres createuser --superuser rails
sudo -u postgres psql -c "ALTER USER rails WITH PASSWORD 'rails';"
```

## Application setup

### Install gems

```bash
bundle install
```

### Configure credentials

Copy the sample config and fill in your Postgres credentials:

```bash
cp config/application.yml.sample config/application.yml
```

Edit `config/application.yml` and set `db_username` and `db_password` to the values you used when creating the Postgres role. The Slack and AWS values are only needed for league features and can be left blank for local development.

**Never commit `application.yml` — it is already in `.gitignore`.**

### Set up the database

```bash
rails db:create db:migrate
```

## Running the app

```bash
rails s
```

Then open [http://localhost:3000](http://localhost:3000) in your browser.

To open a Rails console:

```bash
rails c
```

## Stack versions (as of last update)

| Component  | Version |
|------------|---------|
| Ruby       | 4.0.10  |
| Rails      | 7.2     |
| Node.js    | 26.x    |
| PostgreSQL | 16      |

## Notes

- PostgreSQL in WSL2 does not autostart. Run `sudo service postgresql start` each time you open a new WSL session, or add it to your `.bashrc`/`.profile`.
- `config/application.rb` still uses `config.load_defaults 5.2`. This can be bumped to `7.2` incrementally by enabling new defaults one at a time and verifying nothing breaks.
