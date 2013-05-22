$: << 'lib'

require 'rspec/core/rake_task'
require 'active_record'
require 'certificate_signer/configuration'

include CertificateSigner::Configuration

task default: :spec

RSpec::Core::RakeTask.new(:spec)

namespace :db do
  desc 'Migrate the database (optionally to a specific VERSION)'
  task migrate: :environment do
    version = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
    ActiveRecord::Migrator.migrate 'db/migrate', version
  end
end

task :environment do
  ActiveRecord::Base.establish_connection config['database']
end
