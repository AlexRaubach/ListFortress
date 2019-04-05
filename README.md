# List Fortress


List Fortress is a website for collecting and viewing tournament results for X-Wing Miniatures Second Edition.

Contributions are welcome. Feel free to make a pull request or send me a message if you'd like to coordinate a change.


# Setup 

First install Ruby 2.4.5, a recent version of Node and Postgres. In production the JS compressor closure-compiler requires a recent version of Java. 

* Fork and download the repo `git clone --recurse-submodules ` + the repo url

* Check that the submodule files are present. If you didn't use `--recurse-submodules` then run `git submodule init` + ` git submodule update`

* Create an config file at ./config/application.yml to hold your secrets. A sample file can be found at ./config/application_sample.yml

* Install the required gems `bundle install`

* Set up the database `rails db:create db:migrate db:seed`

* Start the server `rails server`


# API

List Fortress also offers an API for easily exporting tournament data. Currently used by [Pink Brain Matter](https://pinksquadron.dk/pbm/) and soon MetaWing 2.

You can find a list of tournaments at `https://listfortress.com/api/v1/tournaments/ `. Just append a tournament's id to get the participant names, squads and match information if available. 