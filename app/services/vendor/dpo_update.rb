class Services::Vendor::DpoUpdate
  include Utils

  def initialize
    @domain_url = "https://www.d-po.ru"
  end

  def call
    # Обнулить остатки всем товарам поставщика
    # Product.where(vendor: "Dpo").each {|product| product.update(quantity: 0, check: false)}
    get_categories
    get_products
  end

  private

  def get_categories
    doc = get_doc(@domain_url)
    @categories = doc.css("#brands_menu li a").map do |a|
      {
        name: a.text.strip,
        url: "#{@domain_url}/#{a['href']}"
      }
    end
  end

  def get_products
    @categories.each do |category|
      category_url = category[:url]
      category_name = category[:name]

      doc = get_doc category_url

      selector = "#products_content .product .text a"
      products_url = doc.css(selector).map {|a| "#{@domain_url}/#{a['href']}"}
      pagination = get_pagination(doc)

      if pagination.present?
        (2..pagination).each do |page|
          new_category_url = "#{category_url}?page=#{page}"
          new_doc = get_doc new_category_url
          products_url += new_doc.css(selector).map {|a| "#{@domain_url}/#{a['href']}"}
        end
      end
      # p products_url
      # p category_url
      # p products_url.count
      create_update_product(products_url, category_name)
    end
  end

  def create_update_product(products_url, category_name)
    products_url.each do |product_url|
      doc = get_doc(product_url)

      sku = doc.at("qqqqqqqq").text.strip
      fid = "#{sku}___dpo"
      product = Tov.find_by(fid: fid)

      data = {
        check: true
      }

      if product.present?
        next if product.check
        product.update(data)
        next
      else
        create_product(data)
      end

    end
  end

  def get_pagination(doc)
    doc.css(".pagination a").map {|a| a['href'].split("=").last.to_i}.max
  end

  def create_product(data)
    product = Product.new(data)
    if product.save
      pp product
      p "+++++ создан товар #{product.fid} -- всего: #{Product.count}"
    else
      p "!!!!ОШИБКА!!!!! товара #{product.fid}"
    end
  end
end
