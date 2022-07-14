class Product < ApplicationRecord
  VENDOR = [["", "Поставщик"], ["Dpo", "Dpo"]]
  INSALESID = [["", "Статус InSales ID"], [true, "связанные"], [false, "несвязанные"]]
  STATUS_DISTRIBUTOR = [["", "Статус у поставщика"], [true, "true"], [false, "false"]]

  scope :product_all_size, -> { order(:id).size }
  scope :product_qt_not_null, -> { where(quantity: nil) }
  scope :product_qt_not_null_size, -> { where(quantity: nil).size }
  scope :product_cat, -> { order('cat DESC').select(:cat).uniq }
  scope :product_image_nil, -> { where(image: [nil, '']).order(:id) }
end
