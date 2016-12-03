# -*- coding: utf-8 -*-
import scrapy
from scrapy.spider import BaseSpider
from scrapy.selector import Selector
from scrapy.http import Request
from scrapy.http import HtmlResponse
import glob
datastore = open("data.txt", 'wb')


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
            games = Selector(text=body).xpath('//table/tr').extract()
            for q in games:
                vals = Selector(text=q).xpath('//tr/td/text()').extract()
                if(len(vals) > 10) :
                    result = vals[1]
                    teamred = vals[2].split(" ")
                    teamblue = vals[3].split(" ")
                    rtotal = vals[4]
                    rautonomous = vals[5]
                    rteleop = vals[7]
                    rendgame = vals[8]
                    rpenalty = vals[9]
                    btotal = vals[10]
                    bautonomous = vals[11]
                    bteleop = vals[13]
                    bendgame = vals[14]
                    bpenalty = vals[15]
                    print result
            break
