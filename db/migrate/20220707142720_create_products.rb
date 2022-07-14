class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :title
      t.string :link
      t.string :insales_link
      t.string :fid, null: false
      t.string :sku
      t.string :p1
      t.string :vendor
      t.string :manifacture
      t.string :images
      t.string :cat
      t.string :cat1
      t.string :cat2
      t.string :cat3
      t.string :cat4
      t.decimal :price
      t.bigint :quantity
      t.boolean :quantity_insales, default: true
      t.boolean :check, default: true
      t.boolean :insales_check, default: false
      t.bigint :insales_id
      t.bigint :insales_var_id

      t.timestamps
    end
  end
end
