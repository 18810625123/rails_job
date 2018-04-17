class Zhilian < Work

  def parse_base url
    html = open url
    doc = Hpricot html
    divs = doc.search('table')[1..60]
    jobs = divs.map do |div|
      {
        title:div.search('td')[0].search('a')[0].html,
        url:div.search('td')[0].search('a')[0]['href'],
        company_name:div.search('td')[2].search('a')[0].html,
        company_url:div.search('td')[2].search('a')[0]['href'],
        city:div.search('td')[4].html,
        salary:div.search('td')[3].html,
        start:div.search('td')[5].search('span').html,
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
    #   div = doc.search('div[@class="terminalpage-left"]')
    #   lis = div.search('ul[@class="terminal-ul clearfix"]').search('li')
    #   jobs[i]['degree'] = lis[5].search('strong').html
    #   jobs[i]['address'] = div.search('h2').html.split(' ')[0]
    #   jobs[i]['experience'] = lis[4].search('strong').html
    #   jobs[i]['jd'] = div.search('div[@class="tab-inner-cont"]').html
    #   jobs[i]['nature'] = lis[3].search('strong').html
    #   jobs[i]['profession'] = lis[7].search('a')[0].html
    # end
    jobs
  end

end
