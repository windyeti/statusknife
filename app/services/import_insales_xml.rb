class Services::ImportInsalesXml
  def call
    puts '=====>>>> СТАРТ InSales XML '+Time.now.to_s

    Product.all.each do |product|
      product.update(
        insales_link: nil,
        insales_id: nil,
        insales_var_id: nil,
        quantity_insales: true,
        insales_check: false
      )
    end

    uri = "https://statusknife.ru/marketplace/101644.xml"
    response = RestClient.get uri, :accept => :xml, :content_type => "application/xml"
    data = Nokogiri::XML(response)
    offers = data.xpath("//offer")

    offers.each do |pr|
      sku = pr.xpath("sku").text
      fid = "#{sku}___dpo"
      quantity_store_insales = pr.xpath("quantity_store_insales").text

      data = {
        insales_link: pr.xpath("url").text,
        insales_id: pr["group_id"].to_i,
        insales_var_id: pr["id"].to_i,
        quantity_insales: quantity_store_insales,
        insales_check: true
      }
      product = Product.find_by(fid: fid)
      product.update(data) if product.present?
    end
    puts '=====>>>> FINISH InSales XML '+Time.now.to_s
  end
end
