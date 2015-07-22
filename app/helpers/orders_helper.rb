module OrdersHelper
  def format_datetime(datetime)
    datetime.strftime('%-m/%-d/%Y') if datetime
  end
end
