source 'https://rubygems.org'

gem 'activerecord'
gem 'sinatra'
gem 'rake'

group :production do
  gem 'foreman'
  gem 'pg'
  gem 'puma'
end

group :development, :test do
  gem 'sqlite3'
end

group :development do
  gem 'shotgun'
end

group :test do
  gem 'coveralls'
  gem 'factory_girl'
  gem 'guard'
  gem 'guard-rspec'
  gem 'rack-test'
  gem 'rspec'
  gem 'simplecov'
  gem 'webmock'
end
