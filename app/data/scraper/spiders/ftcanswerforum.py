from scrapy.spider import BaseSpider
from scrapy.selector import Selector
from scrapy.http import Request
from scrapy.http import HtmlResponse
import re

def cleanhtml(raw_html):
  cleanr = re.compile('<.*?>')
  cleantext = re.sub(cleanr, '', raw_html)
  return cleantext


datastore = open("forumanswers.txt", 'wb')

class DmozSpider(BaseSpider):
    name = "ftcforum"

    # allowed_domains = ["http://ftcforum.usfirst.org/showthread.php?.*Answer-Thread.*"]
    start_urls = [
    #Answers - Game Rules
    "https://ftcforum.usfirst.org/forum/i-first-i-tech-challenge-game-q-and-a-forum-this-is-a-moderated-forum/first-relic-recovery-presented-by-qualcomm-game-q-a-forum/tournament-rules-aa/answers-tournament-rules-aa/51999-tournament-rules-answers",
    "https://ftcforum.usfirst.org/forum/i-first-i-tech-challenge-game-q-and-a-forum-this-is-a-moderated-forum/first-relic-recovery-presented-by-qualcomm-game-q-a-forum/game-rules-aa/answers-game-rules-aa/50448-scoring-answers",
    "https://ftcforum.usfirst.org/forum/i-first-i-tech-challenge-game-q-and-a-forum-this-is-a-moderated-forum/first-relic-recovery-presented-by-qualcomm-game-q-a-forum/game-rules-aa/answers-game-rules-aa/50452-end-game-answers",
    "https://ftcforum.usfirst.org/forum/i-first-i-tech-challenge-game-q-and-a-forum-this-is-a-moderated-forum/first-relic-recovery-presented-by-qualcomm-game-q-a-forum/game-rules-aa/answers-game-rules-aa/50449-pre-match-answers",
    "https://ftcforum.usfirst.org/forum/i-first-i-tech-challenge-game-q-and-a-forum-this-is-a-moderated-forum/first-relic-recovery-presented-by-qualcomm-game-q-a-forum/game-rules-aa/answers-game-rules-aa/50447-game-play-all-match-periods-answers",
    "https://ftcforum.usfirst.org/forum/i-first-i-tech-challenge-game-q-and-a-forum-this-is-a-moderated-forum/first-relic-recovery-presented-by-qualcomm-game-q-a-forum/game-rules-aa/answers-game-rules-aa/50450-autonomous-period-answers",
    "https://ftcforum.usfirst.org/forum/i-first-i-tech-challenge-game-q-and-a-forum-this-is-a-moderated-forum/first-relic-recovery-presented-by-qualcomm-game-q-a-forum/game-rules-aa/answers-game-rules-aa/50451-driver-controlled-period-answers",
#Answers - Tournament Rules
    "https://ftcforum.usfirst.org/forum/i-first-i-tech-challenge-game-q-and-a-forum-this-is-a-moderated-forum/first-relic-recovery-presented-by-qualcomm-game-q-a-forum/tournament-rules-aa/answers-tournament-rules-aa/51999-tournament-rules-answers",
#Answers - Judging Questions
    "https://ftcforum.usfirst.org/forum/i-first-i-tech-challenge-game-q-and-a-forum-this-is-a-moderated-forum/first-relic-recovery-presented-by-qualcomm-game-q-a-forum/judging-rules/answers-judging-questions/50459-the-engineering-notebook-answers",
    "https://ftcforum.usfirst.org/forum/i-first-i-tech-challenge-game-q-and-a-forum-this-is-a-moderated-forum/first-relic-recovery-presented-by-qualcomm-game-q-a-forum/judging-rules/answers-judging-questions/50458-judges-interview-answers",
    "https://ftcforum.usfirst.org/forum/i-first-i-tech-challenge-game-q-and-a-forum-this-is-a-moderated-forum/first-relic-recovery-presented-by-qualcomm-game-q-a-forum/judging-rules/answers-judging-questions/50456-dean-s-list-rules-answers"
    ]

    def parse(self, response):
        # filename = response.url.split("/")[2]
        questions = Selector(text=response.body).xpath('//div[@class="js-post__content-text OLD__post-content-text restore h-wordwrap"]').extract()
        # print (questions)
        for q in questions:
            # print (q)
            # quote_container
            if len(Selector(text=q).xpath("//div[@class='quote_container']/text()").extract()) == 0:
                continue
            # print(Selector(text=q).xpath("//div[@class='message']/text()").extract())
            title = cleanhtml(" ".join(Selector(text=q).xpath("//div[@class='message']/text()").extract()).replace(" \n ","").strip())
            # if len(Selector(text=q).xpath("//span[@style='color:#FF0000']/text()").extract()) == 0:
            #     continue
            # title = Selector(text=q).xpath("//span[@style='color:#FF0000']/text()").extract()[0].strip()
            answer = Selector(text=q).xpath("//div[@class='js-post__content-text OLD__post-content-text restore h-wordwrap']").extract()[0].strip().replace("\n","").replace("\t","")
            datastore.write(title.encode("utf-8") + "*-1THEREDDKING-*".encode("utf-8") + re.sub(r'(&lt;[^0-9\<h]*(1|2))(?=&gt;)',r'\1&gt;\1g',q.replace("\n","").replace("\r","").replace("\t","")).encode("utf-8") + "*-THEREDDKING-*".encode("utf-8"))
        pages = Selector(text=response.body).xpath('//div[@class="pagination_top"]/form/span/a/@href').extract()
        for p in pages:
            if "javascript" not in p:
                yield Request(response.urljoin(p))
