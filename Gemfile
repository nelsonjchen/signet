source 'https://rubygems.org'

gem 'activerecord'
gem 'sinatra'
gem 'rake'

group :production do
  gem 'pg'
  gem 'puma'
end

group :test do
  gem 'coveralls'
  gem 'factory_girl'
  gem 'guard'
  gem 'guard-rspec'
  gem 'rack-test'
  gem 'rspec'
  gem 'simplecov'
end

group :test, :development do
  gem 'sqlite3'
  gem 'shotgun'
end
