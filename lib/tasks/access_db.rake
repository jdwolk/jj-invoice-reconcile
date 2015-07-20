namespace :access_db do
  desc 'Import JJ MS Access DB backend'
  task import: :environment do
    backend_file = ENV.fetch('ACCESS_DB_BACKEND')

    AccessDBImporter.new.import!(backend_file)
  end
end
