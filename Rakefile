require 'rspec/core/rake_task'
require 'active_record'

task default: :spec

RSpec::Core::RakeTask.new(:spec)

namespace :db do
  desc 'Migrate the database (optionally to a specific VERSION)'
  task migrate: :environment do
    ActiveRecord::Migrator.migrate('db/migrate', ENV['VERSION'] ? ENV['VERSION'].to_i : nil)
  end
end

task :environment do
  ActiveRecord::Base.establish_connection config
end

private

def config
  @config ||= YAML.load_file('config/database.yml')[environment]
end

def environment
  @environment ||= ENV['RACK_ENV'] || defined?(RSpec) ? 'test' : 'development'
end
