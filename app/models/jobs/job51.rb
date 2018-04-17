class Job51 < Work

	def parse_base
		html = open url
		doc = Hpricot html.force_encoding('gbk').encode('utf-8')
		divs = doc.search('div[@class="dw_table"]').search('div[@class="el"]')
		@datas = divs.map do |div|
			{
				title:div.search('a')[0]['title'],
				url:div.search('a')[0]['href'],
				company_name:div.search('a')[1]['title'],
				company_url:div.search('a')[1]['href'],
				city:div.search('span')[2].html,
				salary:div.search('span')[3].html,
				start:div.search('span')[4].html,
				profession:'',
				degree:'',
				address:'',
				nature:'',
				jd:'',
			}
		end
		# opens(jobs.map{|job| job[:url]}).each_with_index do |request,i|
		# 	html = request.response.body
		# 	if(html)
		# 		doc = Hpricot html.force_encoding('gbk').encode('utf-8')
		# 		div = doc.search('div[@class="tCompany_main"]')
		# 		jobs[i]['degree'] = div.search('span')[1].html.split('</em>').last
		# 		jobs[i]['address'] = div.search('div[@class="bmsg inbox"]').search('p')[0].html.split('</span>').last
		# 		jobs[i]['experience'] = div.search('span')[0].html.split('</em>').last
		# 		jobs[i]['jd'] = div.search('div[@class="bmsg job_msg inbox"]')[0].html.split('<div class="mt10">')[0]
		# 	end
		# end
	end

end
