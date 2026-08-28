namespace :custom_tasks do
  desc "Print parse cats"
  task rc: :environment do
    url = "https://www.d-po.ru"
    doc = get_pars_doc(url)

    cats = get_cat(doc, url)
    get_prods(cats, url)
    Rails.logger.info cats
    p cats
  end
  # task t: :environment do
  #   include Utils
  #   doc = get_doc("https://www.d-po.ru/products/noj_SOG_model_MC-02_SOGfari_Machete_-_18")
  #   p price = doc.at(".variants .price").text.strip.remove(/₽|\s/) rescue 0
  #   p quantity = price == 0 ? 0 : nil
  # end
  # def get_manifacture_and_sku(doc)
  #   result = {}
  #   p doc_rows = doc.at(".info").text
  #   doc_rows = doc.css(".info .row")
  #   doc_rows.each do |doc_row|
  #     name = doc_row.at(".name").text
  #     value = doc_row.at(".value").text
  #
  #     result[:manifacture] = value if name == "Производитель:"
  #     result[:sku] = value if name == "Артикул:"
  #   end
  #   result
  # end


end

def get_pars_doc(url)
  url = URI.escape(url)
  Nokogiri::HTML(RestClient::Request.execute(:url => url, :timeout => 100, :method => :get, :verify_ssl => false))
end

def get_cat(doc, url)
  doc.css("#brands_menu li a").map do |a|
    {
      name: a.text.strip,
      url: "#{url}/#{a['href']}"
    }
  end
end

def get_prods(cats, url)
  cats.each do |category|
    category_url = category[:url]
    category_name = category[:name]

    doc = get_pars_doc(category_url)

    selector = "#products_content .product .text a"
    products_url = doc.css(selector).map {|a| "#{url}/#{a['href']}"}
    pagination = get_pagin(doc)

    if pagination.present?
      (2..pagination).each do |page|
        new_category_url = "#{category_url}?page=#{page}"
        new_doc = get_pars_doc(new_category_url)
        products_url += new_doc.css(selector).map {|a| "#{url}/#{a['href']}"}
      end
    end
    # p products_url
    # p category_url
    # p products_url.count
    create_or_update_prod(products_url, category_name)
  end
end

def create_or_update_prod(products_url, category_name)
  products_url.each do |product_url|
    doc = get_pars_doc(product_url)

    p manifacture_and_sku = get_manifac_and_sku(doc)

    sku = manifacture_and_sku[:sku]
    next if sku.nil?

    fid = "#{sku}___dpo"
    product = Product.find_by(fid: fid)

    manifacture = manifacture_and_sku[:manifacture]
    title = doc.at("h1.title").text.strip
    images = doc.at(".product_page .left .image img")['src'] rescue nil
    price = doc.at(".variants .price").text.strip.remove(/₽|\s/) rescue 0
    quantity = price == 0 ? 0 : 99999


    p data_update = {
      price: price,
      quantity: quantity,
      check: true
    }

    p data_create = {
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

    Rails.logger.info data_create
    p data_create

    # if product.present?
    #   next if product.check
    #   product.update(data_update)
    #   next
    # else
    #   create_product(data_create)
    # end
  end
end


def get_pagin(doc)
  doc.css(".pagination a").map {|a| a['href'].split("=").last.to_i}.max
end


def get_manifac_and_sku(doc)
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
