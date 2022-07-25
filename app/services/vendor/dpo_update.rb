class Services::Vendor::DpoUpdate
  include Utils

  def initialize
    @domain_url = "https://www.d-po.ru"
  end

  def call
    # Обнулить остатки всем товарам поставщика
    Product.where(vendor: "Dpo").each {|product| product.update(price: 0, quantity: 0, check: false)}

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
      create_or_update_product(products_url, category_name)
    end
  end

  def create_or_update_product(products_url, category_name)
    products_url.each do |product_url|
      doc = get_doc(product_url)

      p manifacture_and_sku = get_manifacture_and_sku(doc)

      sku = manifacture_and_sku[:sku]
      next if sku.nil?

      fid = "#{sku}___dpo"
      product = Product.find_by(fid: fid)

      manifacture = manifacture_and_sku[:manifacture]
      title = doc.at("h1.title").text.strip
      images = doc.at(".product_page .left .image img")['src'] rescue nil
      price = doc.at(".variants .price").text.strip.remove(/₽|\s/) rescue 0
      quantity = price == 0 ? 0 : nil


      data_update = {
        price: price,
        quantity: quantity,
        check: true
      }

      data_create = {
        fid: fid,
        title: title,
        sku: sku,
        link: product_url,
        vendor: "Dpo",
        manifacture: manifacture,
        images: images,
        cat: "Dpo",
        cat1: category_name,
        price: price,
        quantity: quantity,
        check: true, # explicitly
        insales_check: false # explicitly
      }

      if product.present?
        next if product.check
        product.update(data_update)
        next
      else
        create_product(data_create)
      end
    end
  end

  def get_manifacture_and_sku(doc)
    result = {}
    doc_rows = doc.css(".info .row")
    doc_rows.each do |doc_row|
      name = doc_row.at(".name").text.strip
      value = doc_row.at(".value").text.strip

      result[:manifacture] = value if name == "Производитель:"
      result[:sku] = value if name == "Артикул:"
    end
    result
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
