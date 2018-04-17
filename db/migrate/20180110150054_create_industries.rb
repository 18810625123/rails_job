class CreateIndustries < ActiveRecord::Migration[5.1]
  def change
    create_table :industries do |t|
      t.string :name
      t.string :en

      t.timestamps
    end
  end
end
