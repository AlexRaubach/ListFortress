# List Fortress


List Fortress is a website for collecting and viewing tournament results for X-Wing Miniatures Second Edition.

The collected data is used in [Pink Brain Matter](https://pinksquadron.dk/pbm/), [MetaWing](https://meta.listfortress.com/) and [Advanced Targeting Computer](http://advancedtargeting.computer/).

Contributions are welcome. Feel free to make a pull request or send me a message if you'd like to coordinate a change.


# Setup 

When building a new pc, I tried to document how I ended up installing and configuring everything. [Check out the more detailed write up](Setup.md)

* Install Ruby 2.5.7, a recent version of Node and Postgres. In production the JS compressor, closure-compiler, requires a recent version of Java. 

* Fork and download the repo: `git clone --recurse-submodules ` + the repo url

* Check that the submodule files are present. If you didn't use `--recurse-submodules` then run `git submodule init` + ` git submodule update`

* Create an config file at ./config/application.yml to hold your secrets. A sample file can be found at ./config/application.yml.sample 
  Rename it and add any needed values. The db values are required if on windows but the others are optional.

* Install the required gems: `bundle install`

* Set up the database: `rails db:create db:migrate db:seed`

* Run the task to import xwing_data2 from the submodule: `rails update_xwing_data`

* Start the server: `rails server` or `rails s`


# API

List Fortress also offers an API for easily exporting tournament data.

You can find a list of tournaments at `https://listfortress.com/api/v1/tournaments/ `. Just append a tournament's id to get the participant names, squads and match information if available. 