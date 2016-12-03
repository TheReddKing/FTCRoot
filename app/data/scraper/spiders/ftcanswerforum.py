from scrapy.spider import BaseSpider
from scrapy.selector import Selector
from scrapy.http import Request
from scrapy.http import HtmlResponse

datastore = open("data.txt", 'wb')

class DmozSpider(BaseSpider):
    name = "dmoz"
    
    # allowed_domains = ["http://ftcforum.usfirst.org/showthread.php?.*Answer-Thread.*"]
    start_urls = [
        "http://ftcforum.usfirst.org/showthread.php?6943-Miscellaneous-Game-Questions-Answer-Thread",
        "http://ftcforum.usfirst.org/showthread.php?6939-Driver-Controlled-Period-Answer-Thread",
        "http://ftcforum.usfirst.org/showthread.php?6940-Autonomous-Period-Answer-Thread",
        "http://ftcforum.usfirst.org/showthread.php?6938-End-Game-Answer-Thread",
        "http://ftcforum.usfirst.org/showthread.php?6941-Pre-Match-Answer-Thread",
        "http://ftcforum.usfirst.org/showthread.php?6942-Playing-Field-Answer-Thread"
    ]

    def parse(self, response):
        # filename = response.url.split("/")[2]
        questions = Selector(text=response.body).xpath('//div[@class="postrow"]').extract()
        for q in questions:
            title = Selector(text=q).xpath("//h2/text()").extract()[0].strip()
            # answer = Selector(text=q).xpath("//div[@class='content']").extract()[0].strip().replace("\n","").replace("\t","")
            datastore.write(title.encode("utf-8") + "*-1THEREDDKING-*" + q.replace("\n","").replace("\r","").replace("\t","").encode("utf-8") + "*-THEREDDKING-*")
        pages = Selector(text=response.body).xpath('//div[@class="pagination_top"]/form/span/a/@href').extract()
        for p in pages:
            if "javascript" not in p:
                yield Request(response.urljoin(p))
        