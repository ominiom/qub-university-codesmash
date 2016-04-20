class ReportsController < WebServiceController

  def total_sales
    render json: {
      number_of_sales: Sale.count,
      total: Sale.sum(:total)
    }
  end

  def sales_per_item
    render json: Sale.all.map(&:items)
      .flatten
      .group_by { |item| item['name'] }
      .transform_values { |sales|

        total = sales.map do |sale|
          discount = 0

          if discount_params = sale['discount']
            discount = discount_params['amount']
          end

          sale['price'] - discount
        end.inject(&:+)

        { number_of_sales: sales.count, total: total }
      }
  end

end
