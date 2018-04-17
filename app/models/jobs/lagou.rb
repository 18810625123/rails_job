class Lagou < Work

  def parse_base
    request = Typhoeus::Request.new(url,{method: :post,params:{},
    	headers:{
				Host: 'www.lagou.com',
				Origin: 'https://www.lagou.com',
				Referer: 'https://www.lagou.com/jobs/list_?px=new&yx=10k-15k&city=%E5%8C%97%E4%BA%AC',
				Cookie: 'user_trace_token=20170825205018-f2b1f1d4-8993-11e7-8ed2-5254005c3644; LGUID=20170825205018-f2b1f89e-8993-11e7-8ed2-5254005c3644; _ga=GA1.2.1203854195.1503665418; index_location_city=%E5%85%A8%E5%9B%BD; JSESSIONID=ABAAABAAAFCAAEG6EB6CA19F1DC9693EA59A912821EDD97; Hm_lvt_4233e74dff0ae5bd0a3d81c6ccf756e6=1515422721,1515509921,1516196282,1516711255; TG-TRACK-CODE=index_search; _gid=GA1.2.1060262159.1517325973; _gat=1; LGSID=20180130232553-dc1940e3-05d1-11e8-abde-5254005c3644; PRE_UTM=; PRE_HOST=; PRE_SITE=; PRE_LAND=https%3A%2F%2Fwww.lagou.com%2F; SEARCH_ID=af411bb8e97a496b8d855f0bd1587e28; LGRID=20180130232608-e50e0b17-05d1-11e8-abde-5254005c3644; Hm_lpvt_4233e74dff0ae5bd0a3d81c6ccf756e6=1517325988',
			}
		})
		request.run
		html = request.response.body
		json = JSON.parse html
		@datas = json['content']['positionResult']['result'].map do |a|
			{
        title:a['positionName'],
        url:"https://www.lagou.com/jobs/#{a['positionId']}.html",
        company_name:a['companyFullName'],
        company_url:"https://www.lagou.com/gongsi/#{a['companyId']}.html",
        city:"#{a['city']}-#{a['district']}",
        salary:a['salary'],
        start:a['createTime'],
        profession:a['firstType'],
        degree:a['education'],
        address:a['stationname'],
        nature:'',
        experience:a['workYear'],
        jd:'',
      }
		end
    # opens(jobs.map{|job| job[:url]}).each_with_index do |request,i|
    #   html = request.response.body
    #   doc = Hpricot html
    #   jobs[i]['jd'] = doc.search('dd[@class="job_bt"]').html
    # end
  end


end

