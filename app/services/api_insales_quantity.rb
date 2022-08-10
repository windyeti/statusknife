require 'rest-client'

class Services::ApiInsalesQuantity
  def call
    Product.where(quantity_insales: nil).where.not(insales_var_id: nil).find_in_batches(batch_size: 100) do |products|
      vars = products.map do |product|
        {
          id: product.insales_var_id,
          quantity: product.quantity,
        }
      end
      update_product(vars)
    end
  end


  private

  def update_product(vars)
    url_api_category = "http://#{Rails.application.credentials[:shop][:api_key]}:#{Rails.application.credentials[:shop][:password]}@#{Rails.application.credentials[:shop][:domain]}/admin/products/variants_group_update.json"

    data = {
      "variants": vars
    }

    RestClient.put( url_api_category, data.to_json, :accept => :json, :content_type => "application/json") do |response, request, result, &block|
      case response.code
      when 200
        puts "sleep 1 данные переданы"
        sleep 1
        pp JSON.parse(response.body)
      when 422
        puts "error 422 - не добавили категорию"
        puts response
      when 404
        puts 'error 404'
        puts response
      when 503
        sleep 1
        puts 'sleep 1 error 503'
      else
        puts 'UNKNOWN ERROR'
      end
    end
  end
end
