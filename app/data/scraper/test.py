tournhash = {}
for tournament in open("gameresults/ftc-data/1617velv-event-list.csv","r").read().decode("utf-8").splitlines(False):
    # print tournament
    spl = tournament.split(",")
    tournhash[spl[8]] = spl
currentGame = ""
for game in open("gameresults/ftc-data/1617velv-FULL-MatchResultsDetails.csv","r").read().decode("utf-8").splitlines(False):
    # print game
    if("Result,Red0,Red1" in game):
        continue
    spl = game.split(",")
    tournname = spl[0].split("-")[1]
    print tournname
    if(currentGame != tournname):
        currentGame = tournname
        datastore.write("-THEREDDKING-," + tournhash[currentGame][1] + "," + tournhash[currentGame][0] + "," + tournhash[currentGame][2]+ "\n")
        # 1617velv-gadz-Q-4,Q-4,0-50 B,7437,7432,0,5100,11127,0,0,0,0 ,  0,0,0  ,50,5,0,  45,0, 0,
        #               0    1  2       3    4    5  6   7    8 9 10 11 12 13 14 15 16 17 18 19 20
    datastore.write(spl[1] + "|" + ','.join(spl[3:5]) + "|" + ','.join(spl[6:8]) + "|" + ",".join(spl[9:11] + spl[12:15]) + "|" + ",".join(spl[15:17] + spl[18:21]) + "\n")
    # dategenerated = ""
    # for line in others:
    #     if("generated at " in line):
    #         dategenerated = line.split("generated at ")[1]
    # datastore.write("-THEREDDKING-," + name[0].split("<br>")[0] + "," + dategenerated + "," + filename.split("/")[-2]+ "\n")
    # for q in games:
    #     q = q.replace("*","")
    #     vals = Selector(text=q).xpath('//tr/td/text()').extract()
    #     if(len(vals) > 10) :
    #         name = vals[0].strip()
    #         result = vals[1].strip()
            # teamred = vals[2].strip().split(" ")
            # teamblue = vals[3].strip().split(" ")
            # rtotal = vals[4]
            # rautonomous = vals[5]
            # rteleop = vals[7]
            # rendgame = vals[8]
            # rpenalty = vals[9]
            # r = [rtotal,rautonomous,rteleop,rendgame,rpenalty]
            # btotal = vals[10]
            # bautonomous = vals[11]
            # bteleop = vals[13]
            # bendgame = vals[14]
            # bpenalty = vals[15]
    #         b = [btotal,bautonomous,bteleop,bendgame,bpenalty]
    #         datastore.write(name + "|" + ','.join(teamred) + "|" + ','.join(teamblue) + "|" + ",".join(r) + "|" + ",".join(b) + "\n")
