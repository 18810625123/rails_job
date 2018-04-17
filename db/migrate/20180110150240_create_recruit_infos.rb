class CreateRecruitInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :recruit_infos do |t|
      t.string :job_title
      t.string :target
      t.date :start_at
      t.date :end_at
      t.string :job_city
      t.integer :city_id
      t.integer :company_id
      t.string :job_nature
      t.string :delivery_email
      t.text :jd
      t.string :address
      t.string :salary_min
      t.string :salary_max
      t.integer :source
      t.string :profession
      t.string :checksum

      t.timestamps

      t.index ["city_id"], name: "index_recruit_infos_on_city_id", using: :btree
      t.index ["company_id"], name: "index_recruit_infos_on_company_id", using: :btree
      t.index ["checksum"], name: "index_recruit_infos_on_checksum", unique: true, using: :btree

    end
  end
end
