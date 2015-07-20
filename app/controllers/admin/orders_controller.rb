module Admin
  class OrdersController < BaseController
    def index
      @orders = orders_query
      @clients = Client.where('length(name) > 1').order(name: 'ASC')
    end

    def altisource_report
      @orders = orders_query

      # TODO: filename: "my_new_filename.xlsx"
      render xlsx: 'altisource_report', disposition: 'inline'
    end

    private

    def orders_query
      params[:q] ||= {}

      if params[:q][:client_id_eq].present?
        params[:q][:client_id_eq] = params[:q][:client_id_eq].to_i
      end

      if params[:q][:complete_date_gteq].present?
        params[:q][:complete_date_gteq] = Chronic.parse(params[:q][:complete_date_gteq]).to_date
      end

      if params[:q][:complete_date_lteq].present?
        params[:q][:complete_date_lteq] = Chronic.parse(params[:q][:complete_date_lteq]).to_date
      end

      unpaid_orders = Order.where(paid_date: nil)
      @q = unpaid_orders.ransack(params[:q])

      if params[:q]
        @q.result
          .includes(order_includes)
          .order('complete_date DESC')
          .page(params[:page])
      else
        Order.none
      end
    end

    def order_includes
      [:client]
    end
  end
end
