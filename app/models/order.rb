class Order < ActiveRecord::Base
  belongs_to :client

  monetize :service_fee_cents
end
