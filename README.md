# List Fortress


List Fortress is for collecting and viewing tournament results for the Second Edition of X-Wing Miniatures.

Contributions are welcome. Feel free to make a pull request or send me a message if you'd like to coordinate.


# Setup 

You should have Ruby 2.4.5 installed and Postgres.

* Fork and download the repo `git clone --recurse-submodules ` + the repo url

* Check that the submodule files are present. If you didn't use `--recurse-submodules` then run `git submodule init` + ` git submodule update`

* Create an config file at ./config/application.yml to hold your secrets. A sample file can be found at ./config/application_sample.yml

* Install the required gems `bundle install`

* Set up the database `rails db:create db:migrate db:seed`

* Start the server `rails server`
