module Admin
  class OrdersController < BaseController
    def index
      unpaid_orders = Order.includes(order_includes).where(paid_date: nil)
      @q = unpaid_orders.ransack(params[:q])
      @people = @q.result(distinct: true)
    end

    private

    def order_includes
      [:client]
    end
  end
end
