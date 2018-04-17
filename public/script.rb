request = Typhoeus::Request.new(
  "www.example.com",
  method: :post,
  body: "this is a request body",
  params: { field1: "a field" },
  headers: { Accept: "text/html" }
)

http://search.51job.com/list/010000,000000,0000,00,2,07%252C08%252C09%252C10%252C11,java,2,5.html?lang=c&stype=1&postchannel=0000&workyear=99&cotype=99&degreefrom=03%2C04%2C05&jobterm=99&companysize=99&lonlat=0%2C0&radius=-1&ord_field=0&confirmdate=9&fromType=&dibiaoid=0&address=&line=&specialarea=00&from=&welfare=