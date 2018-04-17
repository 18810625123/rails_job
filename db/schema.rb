# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180325134449) do

  create_table "cities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "en"
    t.string "cn"
    t.integer "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_cities_on_country_id"
  end

  create_table "companies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "cn"
    t.string "en"
    t.string "scale"
    t.string "mature"
    t.integer "source"
    t.integer "industry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["industry_id"], name: "index_companies_on_industry_id"
  end

  create_table "industries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recruit_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "job_title"
    t.string "target"
    t.date "start_at"
    t.date "end_at"
    t.string "job_city"
    t.integer "city_id"
    t.integer "company_id"
    t.string "job_nature"
    t.string "delivery_email"
    t.text "jd"
    t.string "address"
    t.string "salary_min"
    t.string "salary_max"
    t.integer "source"
    t.string "profession"
    t.string "checksum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checksum"], name: "index_recruit_infos_on_checksum", unique: true
    t.index ["city_id"], name: "index_recruit_infos_on_city_id"
    t.index ["company_id"], name: "index_recruit_infos_on_company_id"
  end

  create_table "works", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "job_title"
    t.string "job_url"
    t.string "job_start"
    t.string "job_end"
    t.string "job_city"
    t.string "company_industry"
    t.string "company_scale"
    t.string "company_nature"
    t.string "company_name"
    t.string "company_url"
    t.string "company_website_url"
    t.string "address"
    t.string "degree"
    t.string "salary"
    t.string "salary_min"
    t.string "salary_max"
    t.string "experience"
    t.string "experience_min"
    t.string "experience_max"
    t.string "source"
    t.string "profession"
    t.string "email"
    t.text "jd"
    t.string "checksum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company_address"
    t.string "work_address"
  end

end
