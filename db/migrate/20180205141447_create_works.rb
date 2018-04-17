class CreateWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :works do |t|
      t.string :job_title
      t.string :job_url
      t.string :job_start
      t.string :job_end
      t.string :job_city
      t.string :company_industry
      t.string :company_scale
      t.string :company_nature
      t.string :company_name
      t.string :company_url
      t.string :company_website_url
      t.string :address
      t.string :work_address
      t.string :degree
      t.string :salary
      t.string :salary_min
      t.string :salary_max
      t.string :experience
      t.string :experience_min
      t.string :experience_max
      t.string :source
      t.string :profession
      t.string :email
      t.text :jd
      t.string :checksum

      t.timestamps
    end
  end
end
