# -*- coding: utf-8 -*-
import scrapy
from scrapy.spider import BaseSpider
from scrapy.selector import Selector
from scrapy.http import Request
from scrapy.http import HtmlResponse
import glob
datastore = open("gameresults.txt", 'wb')


class ResultsSpider(BaseSpider):
    name = "results"
    allowed_domains = ["google.com"]
    start_urls = (
        'http://google.com/',
    )
    # def __init__(self, *args, **kwargs):
        # super(MySpider, self).__init__(*args, **kwargs)

    def parse(self, response):
        filename = response.url.split("/")[2]

        for filename in glob.glob("gameresults/*.html"):
            body = open(filename,"r").read().decode("utf-8")
            sel =  Selector(text=body)
            games = sel.xpath('//table/tr').extract()
            name = sel.xpath('//center/h2/text()').extract()
            datastore.write("-THEREDDKING-" + name[0].split("<br>")[0] + "\n")
            for q in games:
                q = q.replace("*","")
                vals = Selector(text=q).xpath('//tr/td/text()').extract()
                if(len(vals) > 10) :
                    result = vals[1]
                    teamred = vals[2].strip().split(" ")
                    teamblue = vals[3].strip().split(" ")
                    rtotal = vals[4]
                    rautonomous = vals[5]
                    rteleop = vals[7]
                    rendgame = vals[8]
                    rpenalty = vals[9]
                    r = [rtotal,rautonomous,rteleop,rendgame,rpenalty]
                    btotal = vals[10]
                    bautonomous = vals[11]
                    bteleop = vals[13]
                    bendgame = vals[14]
                    bpenalty = vals[15]
                    b = [btotal,bautonomous,bteleop,bendgame,bpenalty]
                    datastore.write(','.join(teamred) + "|" + ','.join(teamblue) + "|" + ",".join(r) + "|" + ",".join(b) + "\n")
                    # print result
            # break
