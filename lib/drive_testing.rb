require 'google/api_client'
require 'google_drive'

client = Google::APIClient.new

auth = client.authorization
auth.client_id = ENV.fetch('GOOGLE_CLIENT_ID')
auth.client_secret = ENV.fetch('GOOGLE_CLIENT_SECRET')
auth.refresh_token = ENV.fetch('GOOGLE_REFRESH_TOKEN')
auth.fetch_access_token!

session = GoogleDrive.login_with_oauth(auth.access_token)

#db_files = session.collection_by_title('JJ DB').files
#db_file = db_files.last

db_files = session.collection_by_title('DB_ARCHIVE').files

db_file = db_files.first

tempfile = Rails.root.join('tmp', 'access_db.accdb').to_s

db_file.download_to_file(tempfile)

AccessDBImporter.new.import!(tempfile)

