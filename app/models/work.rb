class Work < ApplicationRecord

	def self.open url, method = :get, params = {}, headers = {}
		request = Typhoeus::Request.new(url,{method:method,params:params,headers:headers})
		request.run
		request.response.body
	end

	def self.opens urls
		hydra = Typhoeus::Hydra.new
		# 创建并行请求
		requests = urls.map do |url|
		  request = Typhoeus::Request.new(url,{method: :get,params:{},headers:{}})
		  hydra.queue(request)
		  request
		end
		# 执行并发请求
		hydra.run
		requests
	end

	def self.saves works
    msgs = []
		works.each do |w|
      if !Work.find_by_checksum(w[:checksum])
  			work = Work.new(w)
        begin
    			work.save
        rescue
          puts "保存失败： #{$!}"
        end
      else
        msg = "#{w[:checksum]} #{w[:job_url]} 已存在"
        msgs << msg
        puts msg
      end
		end
    msgs
	end

	def self.featch url, source
		data = []
		case source
			when '51job'
				data = job51 url
			when 'boss'
				data = boss url
			when 'lagou'
				data = lagou url
			when 'zhilian'
				data = zhilian url
			when 'shixi'
				data = shixi url
			when 'waiyu'
				data = waiyu url
		end
		data
	end

	def self.job51 url
    html = open url
		doc = Hpricot html.force_encoding('gbk').encode('utf-8')
		divs = doc.search('div[@class="dw_table"]').search('div[@class="el"]')
		jobs = divs.map do |div|
			{
        source:'job51',
				job_title:div.search('a')[0]['title'],
				job_url:"http:#{div.search('a')[0]['href']}",
				company_name:div.search('a')[1]['title'],
				company_url:"http:#{div.search('a')[1]['href']}",
				job_city:div.search('span')[2].html,
				salary:div.search('span')[3].html,
				job_start:div.search('span')[4].html,
			}
		end

    opens(jobs.map{|job| job[:job_url]}).each_with_index do |request,i|
      html = request.response.body
      if html.empty?
        puts "null:#{i} #{request.url} "
        html = open request.url
        if(html.empty?)
          next
          puts "\tnull:#{i} #{request.url} "
        end
      else
        puts "ok:#{i} #{request.url}"
      end
      doc = Hpricot html.force_encoding('gbk').encode('utf-8')
      div = doc.search('div[@class="tCompany_main"]')
      spans = div.search('span')
      strs = doc.search('p[@class="msg ltype"]').html.split('|')
      begin
        jobs[i][:experience] = spans[0].html.split('</em>').last
        jobs[i][:degree] = spans[1].html.split('</em>').last
        jobs[i][:work_address] = div.search('div[@class="bmsg inbox"]').search('p')[0].html.split('</span>').last
        jobs[i][:jd] = div.search('div[@class="bmsg job_msg inbox"]')[0].html.split('<div class="mt10">')[0]
        jobs[i][:company_nature] = strs[0].split(' ').first
        jobs[i][:company_website_url] = ''
        jobs[i][:profession] = doc.search('p[@class="fp"]')[0].search('span').html.split("：").last
        jobs[i][:company_scale] = strs[1].split(' ').first.split(';').last
        jobs[i][:company_industry] =  strs[2].split(' ').first.split(';').last
      rescue
        puts "#{$!}\t#{request.url}"
      end
    end

    opens(jobs.map{|job| job[:company_url]}).each_with_index do |request,i|
      html = request.response.body
      if html.empty?
        puts "null:#{i} #{request.url} "
        html = open request.url
        if(html.empty?)
          next
          puts "\tnull:#{i} #{request.url} "
        end
      else
        puts "ok:#{i} #{request.url}"
      end
      doc = Hpricot html.force_encoding('gbk').encode('utf-8')
      begin
        jobs[i][:company_address] = doc.search('p[@class="fp"]')[0].html.split('</span>').last.split(' ')[0]
        jobs[i][:company_website_url] = doc.search('p[@class="fp tmsg"]').search('a')[0][:href]
      rescue
        puts "#{$!}\t#{request.url}"
      end
    end

    jobs.map{|job| formatter('job51',job)}
	end

	def self.boss url
		html = open url
    doc = Hpricot html
    divs = doc.search('div[@class="job-list"]').search('ul').search('li')
    jobs = divs.map do |div|
      p_str = div.search('p')[1].html
      {
        source:'boss',
        job_title:div.search('div[@class="job-title"]').html,
        job_url:'https://www.zhipin.com/'+div.search('a')[0]['href'],
        company_name:div.search('a')[1].html,
        company_url:'https://www.zhipin.com/'+div.search('a')[1]['href'],
        job_city:p_str.split('"')[0].split('<')[0],
        salary:div.search('span')[0].html,
        job_start:div.search('p').last.html.split('于').last,
        job_end:'',
        profession:'',
        degree:p_str.split('"')[4].split('em>').last,
        address:'',
        company_nature:'',
        experience:p_str.split('"')[2].split('em>').last.split('<em').first,
        jd:'',
      }
    end
    
    jobs.map{|job| formatter('boss',job)}
	end

	def self.lagou url
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
    debugger
    
		json = JSON.parse html
		jobs = json['content']['positionResult']['result'].map do |a|
			{
        source:'lagou',
        job_title:a['positionName'],
        job_url:"https://www.lagou.com/jobs/#{a['positionId']}.html",
        company_name:a['companyFullName'],
        company_url:"https://www.lagou.com/gongsi/#{a['companyId']}.html",
        job_city:"#{a['city']}-#{a['district']}",
        salary:a['salary'],
        job_start:a['createTime'],
        job_end:'',
        profession:a['firstType'],
        degree:a['education'],
        address:a['stationname'],
        company_nature:'',
        experience:a['workYear'],
        jd:'',
      }
		end
    jobs.map{|job| formatter('lagou',job)}
	end

	def self.waiyu url
		html = open url
    doc = Hpricot html
    trs = doc.search('tr')[1..20]
    jobs = trs.map do |tr|
      {
        source:'waiyu',
        job_title:tr.search('td')[0].search('a')[0].html,
        job_url:'http://www.jobeast.com/'+tr.search('td')[0].search('a')[0]['href'],
        company_name:tr.search('td')[1].search('a')[0].html,
        company_url:'http://www.jobeast.com/'+tr.search('td')[1].search('a')[0]['href'],
        job_city:tr.search('td')[2].html,
        salary:'',
        job_start:tr.search('td')[3].html.split(' ').first,
        job_end:'',
        profession:'',
        degree:'',
        address:'',
        company_nature:'',
        jd:'',
      }
    end
    jobs.map{|job| formatter('waiyu',job)}
	end

	def self.shixi url
		html = open url
    doc = Hpricot html
    divs = doc.search('div[@class="posi-list"]').search('div[@class="list"]')
    jobs = divs.map do |div|
      {
        source:'shixi',
        job_title:div.search('a')[0].html,
        job_url:"https://www.shixiseng.com"+div.search('a')[0]['href'],
        company_name:div.search('a')[1].html,
        company_url:"https://www.shixiseng.com"+div.search('a')[1]['href'],
        job_city:div.search('span')[0].html,
        salary:div.search('span')[1].html,
      }
    end
    jobs.map{|job| formatter('shixi',job)}
	end

	def self.zhilian url
		html = open url
    doc = Hpricot html
    divs = doc.search('table')[1..60]
    jobs = divs.map do |div|
      {
        source:'zhilian',
        job_title:div.search('td')[0].search('a')[0].html,
        job_url:div.search('td')[0].search('a')[0]['href'],
        company_name:div.search('td')[2].search('a')[0].html,
        company_url:div.search('td')[2].search('a')[0]['href'],
        company_scale:div.search('li[@class="newlist_deatil_two"]').search('span')[2].html.split('：').last,
        company_industry:'',
        job_city:div.search('td')[4].html,
        salary:div.search('td')[3].html,
        job_start:div.search('td')[5].search('span').html,
        degree:div.search('li[@class="newlist_deatil_two"]').search('span')[3].html.split('：').last,
        address:div.search('li[@class="newlist_deatil_two"]').search('span')[0].html.split('：').last,
        company_nature:div.search('li[@class="newlist_deatil_two"]').search('span')[1].html.split('：').last,
      }
    end

    opens(jobs.map{|job| job[:job_url]}).each_with_index do |request,i|
      html = request.response.body
      if html.empty?
        puts "null:#{i} #{request.url} "
        html = open request.url
        if(html.empty?)
          next
          puts "\tnull:#{i} #{request.url} "
        end
      else
        puts "ok:#{i} #{request.url}"
      end
      doc = Hpricot html
      div = doc.search('div[@class="terminalpage-left"]')
      lis = div.search('ul[@class="terminal-ul clearfix"]').search('li')
      right_lis = doc.search('ul[@class="terminal-ul clearfix terminal-company mt20"]').search('li')
      work_address = 
      begin
        jobs[i][:experience] = lis[4].search('strong').html
        jobs[i][:jd] = div.search('div[@class="tab-inner-cont"]')[0].html
        jobs[i][:profession] = lis[7].search('a')[0].html
        jobs[i][:company_industry] = right_lis[2].search('a')[0].html
        jobs[i][:work_address] = div.search('h2')[0].html.split(' ')[0]
      rescue
        puts "#{$!}\t#{request.url}"
      end
    end

    opens(jobs.map{|job| job[:company_url]}).each_with_index do |request,i|
      html = request.response.body
      if html.empty?
        puts "null:#{i} #{request.url} "
        html = open request.url
        if(html.empty?)
          next
          puts "\tnull:#{i} #{request.url} "
        end
      else
        puts "ok:#{i} #{request.url}"
      end
      doc = Hpricot html
      begin
        jobs[i][:company_website_url] = doc.search('table[@class="comTinyDes"]').search('a')[0][:href]
      rescue
        puts "#{$!}\t#{request.url}"
      end
    end

    jobs.map{|job| formatter('zhilian',job)}
	end

  def self.formatter type, work
    if type == 'zhilian'
      if work[:job_start] == '最新' || work[:job_start] == '招聘中'
        work[:job_start] = Time.new.strftime('%Y-%m-%d')
      end
      if work[:salary]
      end
      if work[:experience]
        if work[:experience].include?('年')
          work[:experience] = work[:experience].split('年').first
        else
          work[:experience] = '0'
        end
      end
    end

    if type == 'job51'
      if work[:job_start]
        work[:job_start] = "#{Time.new.year}-#{work[:job_start]}"
      end
      if work[:salary]
        work[:salary] = work[:salary].split('/')[0].split('-').map{|a| (a.to_f * 10000).to_i}.join('-')
      end

      if work[:experience]
        if work[:experience].include?('年')
          work[:experience] = work[:experience].split('年').first
        else
          work[:experience] = '0'
        end
      end
    end

    if type == 'boss'
      if work[:city]
        work[:city] = work[:city].split(' ').join('-')
      end
      if work[:salary]
        work[:salary] = work[:salary].split('-').map{|a| (a.split('K')[0].to_f * 1000).to_i}.join('-')
      end
      if work[:job_start]
        if work[:job_start] == '昨天'
          work[:job_start] = Date.yesterday.to_s 
        elsif work[:job_start].include?(':')
          work[:job_start] = Date.today.to_s 
        elsif work[:job_start].include?('月')
          work[:job_start] = Date.new(Time.new.year,work[:job_start].split('月')[0].to_i, work[:job_start].split('月')[1].split('日')[0].to_i).to_s
        end
      end
      if work[:experience]
        if work[:experience] == '应届生' || work[:experience] == '经验不限' || work[:experience] == '1年以内' 
          work[:experience] = '0'
        else
          work[:experience] = work[:experience].split('年')[0]
        end
      end
    end

    work[:salary_min] = work[:salary].split('-').first if work[:salary]
    work[:salary_max] = work[:salary].split('-').last if work[:salary]
    work[:experience_min] = work[:experience].split('-').first if work[:experience]
    work[:experience_max] = work[:experience].split('-').last if work[:experience]
    work[:checksum] = Digest::MD5.new.hexdigest "#{work[:job_url]}|#{work[:company_url]}"

    # work[:email] = email
    work
  end

end


