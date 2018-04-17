class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :cn
      t.string :en
      t.string :scale
      t.string :mature
      t.integer :source
      t.integer :industry_id
      t.timestamps
      
      t.index ["industry_id"], name: "index_companies_on_industry_id", using: :btree
    end
  end
end
