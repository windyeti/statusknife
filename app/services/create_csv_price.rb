require 'csv'

class Services::CreateCsvPrice
  PRODUCT_STRUCTURE = {
    insales_var_id: 'ID варианта',
    title: 'Название товара',
    price: 'Цена продажи',
    check: 'Параметр: Статус у поставщика',
  }.freeze

  def call
    @file_name_output = "#{Rails.public_path}/product_output_price.csv"
    @tovs = Product.where.not(insales_var_id: nil).order(:id)
    check_previous_files_csv
    create_csv_output(PRODUCT_STRUCTURE)
  end


  private

  def check_previous_files_csv
    FileUtils.rm_rf(Dir.glob(@file_name_output))
  end

  def create_csv_output(product_hash_structure)
    CSV.open(@file_name_output, 'w') do |writer|
      writer << product_hash_structure.values

      @tovs.each do |tov|
        product_properties = product_hash_structure.keys
        product_properties_amount = product_properties.map do |property|
          tov.send(property)
        end
        writer << product_properties_amount
      end
    end
  end
end
