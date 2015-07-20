class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :client
      t.string :service
      t.money :service_fee
      t.date :order_date
      t.date :complete_date
      t.date :paid_date
      t.date :external_reference_num
      t.string :prop_name
    end
  end
end
