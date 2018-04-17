class Boss < Work

  def parse_base
    html = open url
    doc = Hpricot html
    divs = doc.search('div[@class="job-list"]').search('ul').search('li')
    @datas = divs.map do |div|
      p_str = div.search('p')[1].html
      {
        title:div.search('div[@class="job-title"]').html,
        url:'https://www.zhipin.com/'+div.search('a')[0]['href'],
        company_name:div.search('a')[1].html,
        company_url:'https://www.zhipin.com/'+div.search('a')[1]['href'],
        city:p_str.split('"')[0].split('<')[0],
        salary:div.search('span')[0].html,
        start:div.search('p').last.html.split('于').last,
        profession:'',
        degree:p_str.split('"')[4].split('em>').last,
        address:'',
        nature:'',
        experience:p_str.split('"')[2].split('em>').last.split('<em').first,
        jd:'',
      }
    end
    # opens(jobs.map{|job| job[:url]}).each_with_index do |request,i|
    #   html = request.response.body
    #   doc = Hpricot html
    #   div = doc.search('div[@class="detail-content"]')
    #   jobs[i]['address'] = div.search('div[@class="location-address"]').html
    #   jobs[i]['jd'] = div.search('div[@class="text"]').html
    # end
  end

end