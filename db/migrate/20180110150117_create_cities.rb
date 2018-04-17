class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :en
      t.string :cn
      t.integer :country_id

      t.timestamps
      
      t.index ["country_id"], name: "index_cities_on_country_id", using: :btree
    end
  end
end
