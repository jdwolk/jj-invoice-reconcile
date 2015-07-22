class CreateDbUploads < ActiveRecord::Migration
  def change
    create_table :db_uploads do |t|
      t.string :url
      t.datetime :upload_time
      t.timestamps
    end
  end
end
