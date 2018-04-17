def result flag, data, total = nil, msg
  return {
    ok: flag,
    works: data,
    total: total,
    msg: msg
  }
end

class V1 < Grape::API
  content_type :json, 'application/json;charset=utf-8'
  use Rack::Cors do
    allow do
      origins '*'
      resource '*', {
        headers: :any, methods: [:get, :post, :delete, :put, :patch, :options, :head]
      }
    end
  end

  format :json

  get 'abc' do
    Work.last
    # Work.all.each{|work| work.checksum=Digest::MD5.new.hexdigest(work.job_url+'|'+work.company_url);work.save}
  end

  get 'works' do
    puts params
    works = Work.ransack(params).result
    return result(true, works.first(50), works.size, '')
  end

  post '/featch' do
    puts params
    works = Work::featch params['target'], params['source']
    msg = Work::saves(works) if params['save_flag'] == true
    return result(true, works, works.size, msg)
  end

  post '/clue_new' do
    puts params
  end

  get '/excel' do
    # works = Work.ransack(params).result
    works = Work.ransack(source_eq:'zhilian').result.last(200)
    fields = Work.new.attributes.keys
    Ld::Excel.create :file_path => 'public/excel_test.xls' do |excel|
      excel.write_sheet 'works' do |sheet|
        # sheet.set_format({color: :red, font_size: 20, font: '微软雅黑'})
        sheet.set_point 'a1'
        sheet.set_headings fields # ['A','B','C','D']
        sheet.set_rows works.map{|w| fields.map{|k| ['jd','address','created_at','updated_at'].include?(k)? '' : w[k].to_s}}
        # sheet.set_rows([
        #   ['1','2','3','4'],
        #   ['2','3','4','5'],
        #   ['3','4','5','6'],
        #   ['4','5','6','7']
        # ])
      end
    end
    return true
  end

end
