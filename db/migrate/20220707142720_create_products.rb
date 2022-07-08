class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :title
      t.string :link
      t.bigint :insales_link
      t.string :fid, null: false
      t.string :sku
      t.string :vendor
      t.string :images
      t.string :cat
      t.string :cat1
      t.string :price
      t.string :quantity
      t.boolean :check, default: true
      t.boolean :insales_check, default: false
      t.bigint :insales_id
      t.bigint :insales_var_id

      t.timestamps
    end
  end
end
