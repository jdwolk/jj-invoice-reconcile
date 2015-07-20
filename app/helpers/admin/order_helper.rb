module Admin
  module OrderHelper
    def formatted_date(date)
      date.strftime('%-m/%-d/%y') if date
    end
  end
end
