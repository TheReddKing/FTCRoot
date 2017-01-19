# -*- coding: utf-8 -*-
import scrapy
from scrapy.spider import BaseSpider
from scrapy.selector import Selector
from scrapy.http import Request
from scrapy.http import HtmlResponse
import glob
import time
import codecs



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

        helperl = open("parsedgameresults/settings.kf","r").read().decode("utf-8").split("\n")
        helperf = open("parsedgameresults/ftc-dataparse.kf","r").read().decode("utf-8").split("\n")
        datastore = codecs.open("parsedgameresults/migrate" + helperl[0].zfill(4) + "-" + time.strftime("%Y%m%d") + ".txt", 'wb',encoding='utf8')

        repeatedFilenames = []
        repeatedCompetitionnames = []
        repeatedCompetitionnamesAll = []
        i = 1
        while i < len(helperl) - 1:
            repeatedFilenames.append(helperl[i])
            i+=1
        i = 1
        while i < len(helperf):
            repeatedCompetitionnames.append(helperf[i-1].split("|")[0])
            repeatedCompetitionnamesAll.append(helperf[i-1])
            i+=1



        # THIS IS FOR DETAILS ONLY
        for filename in glob.glob("gameresults/**/*.html"):
            if filename in repeatedFilenames:
                continue
            repeatedFilenames.append(filename)
            body = open(filename,"r").read().decode("utf-8")
            sel =  Selector(text=body)
            games = sel.xpath('//table/tr').extract()
            name = sel.xpath('//center/h2/text()').extract()
            others = sel.xpath("//center/small/text()").extract()
            dategenerated = ""
            for line in others:
                if("generated at " in line):
                    dategenerated = line.split("generated at ")[1]
            datastore.write("-THEREDDKING-," + name[0].split("<br>")[0].encode('utf-8') + "," + dategenerated.encode('utf-8') + "," + filename.split("/")[-2].encode('utf-8')+ "\n")
            for q in games:
                q = q.replace("*","")
                vals = Selector(text=q).xpath('//tr/td/text()').extract()
                if(len(vals) > 10) :
                    name = vals[0].strip()
                    result = vals[1].strip()
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
                    datastore.write(name + "|" + ','.join(teamred) + "|" + ','.join(teamblue) + "|" + ",".join(r) + "|" + ",".join(b) + "\n")
                # NOW WE LOOKING GOOOOOD WITH NO DETAILS
                elif(len(vals) > 3) :
                    name = vals[0].strip()
                    result = vals[1].strip()
                    teamred = [vals[2].strip()]
                    teamblue = [vals[3].strip()]
                elif(len(vals) > 1) :
                    if(len(teamred) == 2):
                        continue
                    scores = result.replace(" R","").replace(" B","").replace(" T","").split("-")
                    teamred.append(vals[0].strip())
                    teamblue.append(vals[1].strip())
                    rtotal = scores[0]
                    rautonomous = "-1"
                    rteleop = "-1"
                    rendgame = "-1"
                    rpenalty = "-1"
                    r = [rtotal,rautonomous,rteleop,rendgame,rpenalty]
                    btotal = scores[1]
                    bautonomous = "-1"
                    bteleop = "-1"
                    bendgame = "-1"
                    bpenalty = "-1"
                    b = [btotal,bautonomous,bteleop,bendgame,bpenalty]
                    datastore.write(name + "|" + ','.join(teamred) + "|" + ','.join(teamblue) + "|" + ",".join(r) + "|" + ",".join(b) + "\n")

        # Special!!!
        tournhash = {}
        for tournament in open("gameresults/ftc-data/1617velv-event-list.csv","r").read().decode("utf-8").splitlines(False):
            print tournament
            spl = tournament.split(",")
            tournhash[spl[8]] = spl

        currentGame = ""
        for game in open("gameresults/ftc-data/1617velv-FULL-MatchResultsDetails.csv","r").read().decode("utf-8").splitlines(False):
            if("Result,Red0,Red1" in game):
                continue
            spl = game.split(",")
            tournname = spl[0].split("-")[1]

            if tournname in repeatedCompetitionnames:
                continue

            if(currentGame != tournname):
                currentGame = tournname
                date = tournhash[currentGame][0].replace("2016","16").replace("2017","17").split("/")
                if(len(date[1]) == 1):
                    date = date[0] + "/0" + date[1] + "/" + date[2]
                else:
                    date = date[0] + "/" + date[1] + "/" + date[2]
                datastore.write("-THEREDDKING-," + tournhash[currentGame][1].encode('utf-8') + "," + date.encode('utf-8') + "," + tournhash[currentGame][2].split(" -")[0].encode('utf-8')+ "\n")
                # repeatedCompetitionnames.append(currentGame + "")
                repeatedCompetitionnamesAll.append(currentGame + "|" + tournhash[currentGame][1] + "|" + date)
                # 1617velv-gadz-Q-4,Q-4,0-50 B,7437,7432,0,5100,11127,0,0,0,0 ,  0,0,0  ,50,5,0,  45,0, 0,
                #               0    1  2       3    4    5  6   7    8 9 10 11 12 13 14 15 16 17 18 19 20
            datastore.write(spl[1] + "|" + ','.join(spl[3:5]) + "|" + ','.join(spl[6:8]) + "|" + ",".join(spl[9:11] + spl[12:15]) + "|" + ",".join(spl[15:17] + spl[18:21]) + "\n")


        helper = open("parsedgameresults/settings.kf", 'wb')
        helper.write(str((int(helperl[0]) + 1)) + "\n")
        for file in repeatedFilenames:
            helper.write(file + "\n")

        helper = open("parsedgameresults/ftc-dataparse.kf", 'wb')
        for file in repeatedCompetitionnamesAll:
            helper.write(file + "\n")
