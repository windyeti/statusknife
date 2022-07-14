namespace :p do
  task t: :environment do
    include Utils
    doc = get_doc("https://www.d-po.ru/products/nozh-artisan-cutlery-1808p-bkc-zumwalt")
    p get_manifacture_and_sku(doc)
  end
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
