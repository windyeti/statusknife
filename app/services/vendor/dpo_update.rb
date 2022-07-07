class Services::Vendor::DpoUpdate
  include Utils

  def initialize
    @domain_url = "https://www.d-po.ru"
  end

  def call
    # Обнулить остатки всем товарам поставщика
    # Product.where(vendor: "Dpo").each {|product| product.update(quantity: 0)}
    get_categories
    get_products
  end

  private

  def get_categories
    doc = get_doc(@domain_url)
    @categories_url = doc.css("#catalog_menu li a").map {|a| "#{@domain_url}/#{a['href']}"}
  end

  def get_products
    @categories_url.each do |category_url|
      doc = get_doc category_url

      selector = "#products_content .product .text a"
      product_url = doc.css(selector).map {|a| "#{@domain_url}/#{a['href']}"}
      pagination = get_pagination(doc)

      if pagination.present?
        (2..pagination).each do |page|
          new_category_url = "#{category_url}?page=#{page}"
          new_doc = get_doc new_category_url
          product_url += new_doc.css(selector).map {|a| "#{@domain_url}/#{a['href']}"}
        end
      end
      p product_url
      p category_url
      p product_url.count
    end
  end

  def get_pagination(doc)
    doc.css(".pagination a").map {|a| a['href'].split("=").last.to_i}.max
  end
end
