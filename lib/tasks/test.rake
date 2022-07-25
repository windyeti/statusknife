namespace :p do
  task t: :environment do
    include Utils
    doc = get_doc("https://www.d-po.ru/products/noj_SOG_model_MC-02_SOGfari_Machete_-_18")
    p price = doc.at(".variants .price").text.strip.remove(/₽|\s/) rescue 0
    p quantity = price == 0 ? 0 : nil
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
