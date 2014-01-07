require 'octopus'

require 'active_record_migrations'

db_config = YAML.load_file('./config/databases.yml')

ActiveRecordMigrations.configure do |c|
  c.database_configuration = { 'production' => db_config['je'] }
  # Other settings:
  # c.schema_format = :sql # default is :ruby
  c.yaml_config = 'config/databases.yml'

  c.environment = 'production' # ENV['db']
  # c.db_dir = 'db'
  # c.migrations_paths = ['db/migrate'] # the first entry will be used by the generator
end
ActiveRecord::Base.timestamped_migrations = false
ActiveRecordMigrations.load_tasks

