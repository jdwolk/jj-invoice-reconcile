module UnpaidOrders
  class Altisource < ReportCard::Report
    def to_csv(csv)
      csv << [
        'Altisource File #',
        'Vendor Invoice Amt',
        'Date of Income'
      ]

      Order.find_each do |order|
        csv << [
          order.external_reference_num,
          order.service_fee,
          order.complete_date
        ]
      end
    end
  end
end
