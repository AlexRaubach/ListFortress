source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.7'

gem 'rails', '~> 7.2'
# Use postgres as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sassc-rails'

# Uglifier for JavaScript compression
gem 'uglifier'
# ExecJS runtime
gem 'mini_racer'
# Turbolinks makes navigating your web application faster
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease
gem 'jbuilder', '~> 2.5'

# Sign in with google / slack
gem 'ginjo-omniauth-slack', '~> 2.4.1'
# gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection', '~> 0.1'
gem 'omniauth', '~> 1.9'

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

# Use Dalli and connection_pool for memcached
gem 'connection_pool', '~> 2.5' # 3.x is incompatible with Rails 7.2's MemCacheStore
gem 'dalli'

# Use has_scope to easily filter models
gem 'has_scope'

gem 'rack-cors'
gem 'listen'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'debase'
  gem 'ruby-debug-ide'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# Now unneeded since development is via WSL.
# Uncomment if you want to develop on Windows
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'active_model_serializers', '~> 0.10.0'
