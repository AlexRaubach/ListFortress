# List Fortress


List Fortress is for collecting and viewing tournament results for the Second Edition of X-Wing Miniatures.

Contributions are welcome. Feel free to make a pull request or send me a message if you'd like to coordinate.


# Setup 

You should have Ruby 2.4.4 installed and Postgres.

* Fork and download the repo `git clone --recurse-submodules ...`

* Check that the submodule files are present. If you didn't use `--recurse-submodules` then run `git submodule init` + ` git submodule update`

* Create ./config/application.yml file with the following secrets for your Postgres install.

  * db_username: user
  * db_password: password

* Install the required gems `bundle install`

* Set up the database `rails db:create db:migrate db:seed`

* Start the server `rails server`
