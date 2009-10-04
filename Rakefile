require 'active_record'
require 'yaml'

task :default => :migrate

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate => :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :environment do
  db_yml = File.join(File.dirname(__FILE__),'db/database.yml')
  db_log = File.join(File.dirname(__FILE__),'db/database.log')
  ActiveRecord::Base.establish_connection(YAML::load(File.open(db_yml)))
  ActiveRecord::Base.logger = Logger.new(File.open(db_log, 'a'))
end