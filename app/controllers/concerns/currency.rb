module Currency
  extend ActiveSupport::Concern

  def ensure_cents
    if params[:unit_price]
      float_price = params[:unit_price].to_f
      int_price = params[:unit_price].to_i
      if float_price == int_price.to_f
        params[:unit_price] = int_price
      else
        params[:unit_price] = (float_price * 100).round(0).to_i
      end
    end
  end
end
