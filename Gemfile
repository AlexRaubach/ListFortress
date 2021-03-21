source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1'
# Use postgres as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use closure-compiler as compressor for JavaScript assets
# gem 'closure-compiler'

# Uglifier had problems in the past but maybe it just works now?
gem 'uglifier'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Sign in with google / slack
gem 'ginjo-omniauth-slack', '~> 2.4.1'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection', '~> 0.1'

# manage secrets
gem 'figaro'

# Pagination
gem 'will_paginate', '~> 3.1.0'
gem 'will_paginate-bootstrap4'

# Use a gem for country selection dropdown
gem 'country_select'

# Use a gem for easier http requests
gem 'httparty'

# Use Bootstrap for application styling
gem 'bootstrap', '~> 4.3.1'
gem 'bootstrap_form'
gem 'jquery-rails'

# Use Font Awesome as a glyph source
gem 'font-awesome-sass', '~> 5.8.1'

# Use S3 and Active Storage
gem 'aws-sdk-s3', require: false
gem 'mini_magick'
gem 'image_processing'

# Use NewRelic for application profiling
# gem 'newrelic_rpm'

# Use Barnes for heroku metrics
gem 'barnes'

# Use Dallii and connectionpool for memcached
gem 'connection_pool'
gem 'dalli'

# Use has_scope to easily filter models
gem 'has_scope'


gem 'listen'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# Now unneeded since development is via WSL. 
# Uncomment if you want to develop on Windows
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'active_model_serializers', '~> 0.10.0'
