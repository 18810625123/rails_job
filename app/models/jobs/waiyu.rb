class Waiyu < Work

  def parse_base
    html = open url
    doc = Hpricot html
    trs = doc.search('tr')[1..20]
    @datas = trs.map do |tr|
      {
        title:tr.search('td')[0].search('a')[0].html,
        url:'http://www.jobeast.com/'+tr.search('td')[0].search('a')[0]['href'],
        company_name:tr.search('td')[1].search('a')[0].html,
        company_url:'http://www.jobeast.com/'+tr.search('td')[1].search('a')[0]['href'],
        city:tr.search('td')[2].html,
        salary:'',
        start:tr.search('td')[3].html.split(' ').first,
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
    #   div = doc.search('ol[@class="jobDetails_info"]')
    #   jobs[i]['salary'] = div.search('span')[0].html.split(' ').last
    #   jobs[i]['degree'] = div.search('span')[2].html
    #   jobs[i]['address'] = div.search('li[@id="LinkMan"]').search('p')[2].html.split('</label>').last.split('<a id=')[0]
    #   jobs[i]['experience'] = div.search('span')[3].html
    #   jobs[i]['jd'] = div.search('p')[7].html
    #   jobs[i]['nature'] = div.search('p')[5].html.split('：').last
    # end
    jobs
  end

end