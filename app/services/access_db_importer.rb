require 'fileutils'
require 'csv'

class AccessDBImporter
  CSV_SCRIPT = Rails.root.join('lib', 'tables_to_csv.sh')
  CSV_DATA_DIR = Rails.root.join('tmp', 'csv_data')

  ORDERS_CSV = CSV_DATA_DIR.join('tblOrders.csv')
  CLIENTS_CSV = CSV_DATA_DIR.join('tblClientList.csv')

  def initialize
    drop_db if ENV['DROP_DB']
    create_csv_dir!
  end

  def import!(access_db_backend_file)
    puts "Importing data from #{access_db_backend_file}"
    to_csvs!(access_db_backend_file)

    ActiveRecord::Base.transaction do
      models_to_csvs.each do |model, csv_file|
        CSVImporter.new(csv_file, model).import!
      end
      track_upload!(access_db_backend_file)
    end
  end

  private

  def models_to_csvs
    {
      Order  => ORDERS_CSV,
      Client => CLIENTS_CSV
    }
  end

  def to_csvs!(access_db_backend_file)
    `#{CSV_SCRIPT} #{access_db_backend_file} #{csv_dir}`
  end

  def drop_db
    puts 'Dropping existing Orders and Clients'
    Order.destroy_all
    Client.destroy_all
  end

  def track_upload!(_db_url)
    DBUpload.create!(upload_time: Time.now)
  end

  def create_csv_dir!
    if File.exist?(csv_dir)
      puts 'Removing existing csv dir'
      FileUtils.rmdir(csv_dir)
    end
    puts 'Creating csv dir'
    FileUtils.mkdir_p(csv_dir)
    puts 'Done creating csvs for Access DB tables'
  end

  def csv_dir
    CSV_DATA_DIR
  end

  class CSVImporter
    module GenericCSVImporter
      def import!
        read_csv(csv_file, &method(:create!))
      end

      def parse_date(date)
        Date.parse(date) if date
      end

      def parse_money(amt)
        amt.try { |val| (val.to_f * 100).to_i } || 0
      end

      private

      def read_csv(csv, &blk)
        CSV.foreach(csv_file, headers: true, header_converters: :symbol) do |row|
          blk.call(row)
        end
      end
    end

    attr_reader :csv_file, :model

    def initialize(csv_file, model)
      @model = model
      @csv_file = csv_file
    end

    def import!
      importer.import!
    end

    private

    def importer
      case model.new
      when Order then ForOrders.new(csv_file)
      when Client then ForClients.new(csv_file)
      else fail "Unrecognized model `#{model}`"
      end
    end

    class ForOrders < Struct.new(:csv_file)
      include GenericCSVImporter

      def create!(row)
        Order.find_or_create_by!(
          id: row[:orderid].to_i,
          client_id: row[:client].to_i,
          service: row[:service],
          service_fee_cents: parse_money(row[:servicefee]),
          order_date: parse_date(row[:orderdate]),
          complete_date: parse_date(row[:completedate]),
          paid_date: parse_date(row[:paiddate]),
          external_reference_num: row[:refno],
          prop_name: row[:propname]
        )
      rescue Exception => e
      end
    end

    class ForClients < Struct.new(:csv_file)
      include GenericCSVImporter

      def create!(row)
        Client.find_or_create_by!(
          id: row[:clientid].to_i,
          name: row[:client],
          contact: row[:contact]
        )
      end
    end
  end
end
