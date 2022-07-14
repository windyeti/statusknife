require 'csv'

class Services::CreateCsvSelected
  PRODUCT_STRUCTURE = {
    title: "Название товара",
    link: "Параметр: Ссылка на товар у производителя",
    insales_link: "Параметр: Ссылка на товар в инсайлс",
    fid: "Параметр: fid",
    sku: "Артикул",
    vendor: "Параметр: Поставщик",
    manifacture: "Параметр: Приозводитель",
    images: "Изображения товара",
    cat: "Корневая",
    cat1: "Подкатегория 1",
    cat2: "Подкатегория 2",
    cat3: "Подкатегория 3",
    cat4: "Подкатегория 4",
    price: "Цена продажи",
    quantity: "Остаток",
    check: "Параметр: Статус у поставщика",
    insales_check: "Параметр: Статус в инсайлс",
    insales_id: "ID товара",
    insales_var_id: "ID варианта",
  }.freeze

  def initialize(product_ids)
    @tovs = Product.where(id: product_ids).order(:id)
    @pre_file = "#{Rails.root}/public/pre_products_selected.csv"
    @output_file = Rails.public_path.to_s + '/product_selected.csv'
  end

  def call
    check_previous_files_csv
    create_csv_output(PRODUCT_STRUCTURE)
  end


  private

  def check_previous_files_csv
    FileUtils.rm_rf(Dir.glob(@pre_file))
    FileUtils.rm_rf(Dir.glob(@output_file))
  end

  def create_csv_output(product_hash_structure)
    CSV.open(@pre_file, 'w') do |writer|
      writer << product_hash_structure.values

      @tovs.each do |tov|
        product_properties = product_hash_structure.keys
        product_properties_amount = product_properties.map do |property|
          tov.send(property)
        end
        writer << product_properties_amount
      end
    end

    vparamHeader = []
    p = @tovs.select(:p1)
    p.each do |p|
      next if p.p1.nil?
      p.p1.split(' --- ').each do |pa|
        vparamHeader << pa.split(':')[0].strip unless pa.nil?
      end
    end
    addHeaders = vparamHeader.uniq

    rows = CSV.read(@pre_file, headers: true).collect do |row|
      row.to_hash
    end

    column_names = rows.first.keys
    addHeaders.each do |addH|

      additional_column_names = ['Параметр: ' + addH]
      column_names += additional_column_names
      s = CSV.generate do |csv|
        csv << column_names
        rows.each do |row|
          values = row.values
          csv << values
        end
      end
      File.open(@pre_file, 'w') { |file| file.write(s) }
    end

    # заполняем параметры по каждому товару в файле
    CSV.open(@output_file, 'w') do |csv_out|
      rows = CSV.read(@pre_file, headers: true).collect do |row|
        row.to_hash
      end
      column_names = rows.first.keys
      csv_out << column_names
      CSV.foreach(@pre_file, headers: true) do |row|
        fid = row[0]
        vel = Product.find_by(fid: fid)
        if !vel.nil? && vel.p1.present? # Вид записи должен быть типа - "Длина рамы: 20 --- Ширина рамы: 30"
          p vel.p1
          vel.p1.split(' --- ').each do |vp|
            key = 'Параметр: ' + vp.split(':')[0].strip
            value = vp.split(':')[1] unless vp.split(':')[1].nil?
            row[key] = value
          end
        end
        csv_out << row
      end
    end
  end
end
