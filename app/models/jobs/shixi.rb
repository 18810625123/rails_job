class Shixi < Work

  def parse_base
    html = open url
    doc = Hpricot html
    divs = doc.search('div[@class="posi-list"]').search('div[@class="list"]')
    @datas = divs.map do |div|
      {
        title:div.search('a')[0].html,
        url:"https://www.shixiseng.com"+div.search('a')[0]['href'],
        company_name:div.search('a')[1].html,
        company_url:"https://www.shixiseng.com"+div.search('a')[1]['href'],
        city:div.search('span')[0].html,
        salary:div.search('span')[1].html,
        start:'',
        profession:'',
        degree:'',
        address:'',
        nature:'',
        jd:'',
      }
    end
    # opens(jobs.map{|job| job[:url]}).each_with_index do |request,i|
    #   html = request.response.body
    #   doc = Hpricot html
    #   div = doc.search('div[@class="tCompany_main"]')
    #   jobs[i]['address'] = doc.search('span[@class="com_position"]').html
    #   jobs[i]['jd'] = doc.search('div[@class="job_detail"]').html
    #   jobs[i]['start'] = doc.search('span[@class="cutom_font"]').html
    #   jobs[i]['degree'] = doc.search('span[@class="job_academic"]').html
    # end
  end
  
end

