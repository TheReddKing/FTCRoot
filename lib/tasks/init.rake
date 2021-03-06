# rails init:load
namespace :init do
    desc 'Load all teams into database'
    task load: :environment do
        class FTCTeam
            attr_accessor :id, :name, :address, :latlong, :website
            def initialize(jason)
                # puts jason
                @id = jason['id']
                @name = jason['name']
                @address = jason['address']
                @latlong = jason['latlong']
                @website = jason['website']
            end

            def lat
                latlong[0].to_s
            end

            def long
                latlong[1].to_s
            end
        end

        files = Dir["#{Rails.root}/app/data/teams/*.txt"]
        for file in files
            File.read(file).each_line do |line|
                ftcteam = FTCTeam.new(JSON.parse(line))
                # For testing purposes only
                # :name, :id, :location, :location_lat, :location_long
                if(!Team.exists?(ftcteam.id))
                    team = Team.new(name: ftcteam.name, id: ftcteam.id, location: ftcteam.address, location_lat: ftcteam.lat.to_f, location_long: ftcteam.long.to_f,website:ftcteam.website,data_competitions:"")
                    team.save
                end
            end
        end
    end
    desc 'Load all team updates'
    task T: :environment do
        files = Dir["#{Rails.root}/app/data/teams/*.update"]
        for file in files
            File.read(file).each_line do |line|
                ftcteam = JSON.parse(line, object_class: OpenStruct)
                # For testing purposes only
                # :name, :id, :location, :location_lat, :location_long
                if(Team.exists?(ftcteam.id))
                    team = Team.find(ftcteam.id)
                    if(ftcteam.blurb != nil)
                       team.blurb = ftcteam.blurb
                    end
                    if(ftcteam.contact_email != nil)
                        team.contact_email = ftcteam.contact_email
                    end
                    if(ftcteam.contact_twitter != nil)
                        team.contact_twitter = ftcteam.contact_twitter
                    end
                    if(ftcteam.website != nil)
                        team.website = ftcteam.website
                    end
                    if(ftcteam.contact_facebook != nil)
                        team.contact_facebook = ftcteam.contact_facebook
                    end
                    if(ftcteam.contact_youtube != nil)
                        team.contact_youtube = ftcteam.contact_youtube
                    end
                    team.save
                end
            end
        end
    end

    desc 'Raw stats load'
    task O: :environment do
        # for meet in Event.all
        #     meet.data_raw = ""
        #     meet.save
        # end
        puts "End Clear"

        currentMeet = nil
        File.read("#{Rails.root}/app/data/gameresults/ftc-data/1617velv-FULL-MatchResultsRaw.csv").each_line do |line|
            if line.include?("Red1,Red2")
                next
            end
            spl = line.split(",")
            fullcomp = spl[0].split("-")
            tournname = fullcomp[1] + "-" + fullcomp[2]
            qualName = fullcomp[3..fullcomp.length].join("-")
            meet = Event.where(ftcmatchcode:tournname).first
            if(!currentMeet or currentMeet.id != meet.id)
                if(currentMeet)
                    currentMeet.save
                end
                currentMeet = meet
            end
            if(currentMeet != nil)
                currentMeet.advancedraw = true
                if(currentMeet.data_raw.length == 0)
                    # We going for beacons
                    currentMeet.data_raw = "#{qualName},#{spl[29..56].join(",")}"
                else
                    currentMeet.data_raw = currentMeet.data_raw + "|#{qualName},#{spl[29..56].join(",")}"
                end
            else
                puts "Error meet not found: " + spl[0]
            end
        end
        currentMeet.save
        puts "DONE"
    end

    desc 'Results stuff'
    task N: :environment do
        #
        # for meet in Event.all
        #     meet.data_stats = ""
        #     meet.save
        # end

        currentMeet = nil
        File.read("#{Rails.root}/app/data/gameresults/ftc-data/1617velv-FULL-StatsRes.csv").each_line do |line|
            if line.include?("TournamentCode,Num")
                next
            end
            spl = line.split(",")
            # puts line
            tournname = spl[0].split("-")[1] + "-" + spl[0].split("-")[2]
            meet = Event.where(ftcmatchcode:tournname).first
            if(meet != nil)
                meet.advancedstats = true
                if(meet.data_stats.length == 0)
                    meet.data_stats = "#{spl[1]},#{spl[3,9].join(",")}"
                else
                    meet.data_stats = meet.data_stats + "|#{spl[1]},#{spl[3,9].join(",")}"
                end
                meet.save
                # TournamentCode,   Num,    Name        ,R,QP,RP    ,High   ,MP ,Elim   ,WP,OPR,OPRm,
                # 1617velv-akea,    3208,   Rocket 4.0  ,1,10,126   ,115    ,5  ,       ,1.00,58.7,51.6,
                # 0                 1           2       ,3,4 ,5     ,6  ,7
            end
        end
        # TournamentCode,Num,Name,R,QP,RP,High,MP,Elim,WP,OPR,OPRm,OPR-,OPRm-,OPRA,OPRmA,OPRB,OPRmB,OPRT,OPRmT,OPRE,OPRmE,OPRP,OPRmP,OPRp,OPRmp,
        File.read("#{Rails.root}/app/data/gameresults/ftc-data/1617velv-FULL-StatsDet.csv").each_line do |line|
            if line.include?("TournamentCode,Num")
                next
            end
            spl = line.split(",")
            # puts line
            tournname = spl[0].split("-")[1] + "-" + spl[0].split("-")[2]
            meet = Event.where(ftcmatchcode:tournname).first
            if(meet != nil)
                meet.advancedstats = false
                if(meet.data_stats.length == 0)
                    meet.data_stats = "#{spl[1]},#{spl[3,23].join(",")}"
                else
                    meet.data_stats = meet.data_stats + "|#{spl[1]},#{spl[3,23].join(",")}"
                end
                meet.save
                # TournamentCode,   Num,    Name        ,R,QP,RP    ,High   ,MP ,Elim   ,WP,OPR,OPRm,
                # 1617velv-akea,    3208,   Rocket 4.0  ,1,10,126   ,115    ,5  ,       ,1.00,58.7,51.6,
                # 0                 1           2       ,3,4 ,5     ,6  ,7
            end
        end
    end

    desc 'Load all events list'
    task M: :environment do
        # if Time.now.tuesday? or Time.now.wednesday? or Time.now.thursday? or Time.now.friday? or Time.now.saturday? or Time.now.sunday?
        #     return
        # end
        File.read("#{Rails.root}/app/data/gameresults/ftc-data/1617velv-event-list.csv").each_line do |line|
            spl = line.split(',')
            region = Region.where(name:spl[2])[0]
            if(region == nil)
                region = Region.new(name:spl[2])
                region.save
            end
            meet = Event.where(ftcmatchcode:spl[8])[0]
            if(meet == nil)
                meet = Event.new(name: spl[1],date:spl[0],location:spl[2],ftcmatchcode:spl[8],competitiontype:spl[3],data_competition:"")
                meet.region = region
                meet.save
                region.save
            else
                meet.date = spl[0]
                meet.name = spl[1]
                meet.competitiontype = spl[3]
                meet.save
            end
        end
        for meet in Event.all
            meet.data_competition = ""
            meet.data_stats = ""
            meet.data_raw = ""
            meet.save
        end
        for team in Team.all
            team.data_competitions = ""
            team.data_strong = ""
            team.save
        end
        # For events with no details
        puts "BEGIN"
        currentMeet = nil
        File.read("#{Rails.root}/app/data/gameresults/ftc-data/1617velv-FULL-MatchResults.csv").each_line do |line|
            if line.include?("Red1,Red2")
                next
            end
            spl = line.split(",")
            tournname = spl[0].split("-")[1] + "-" + spl[0].split("-")[2]

            if(!currentMeet or currentMeet.ftcmatchcode != tournname)
                meet = Event.where(ftcmatchcode:tournname).first
                if(currentMeet)
                    currentMeet.save
                end
                puts "Meet #{meet.id}"
                currentMeet = meet
            end

            if(currentMeet != nil)
                currentMeet.advanceddata = false
                if(currentMeet.data_competition.length == 0)
                    currentMeet.data_competition = "#{spl[1]},#{spl[3,8].join(",")}"
                else
                    currentMeet.data_competition = currentMeet.data_competition + "|#{spl[1]},#{spl[3,8].join(",")}"
                end
                # meet.save

                # TEAMSS
                teams = []
                for teamid in spl[3,6]
                    if(Team.exists?(teamid))
                        teams.push(Team.find(teamid))
                    end
                end
                for team in teams
                    if(team == nil)
                        next
                    end
                    if(team.data_competitions.include?("#{meet.id}_"))
                        next
                    end
                    if(team.data_competitions.length == 0)
                        team.data_competitions = "#{meet.id}_"
                    else
                        team.data_competitions += "|#{meet.id}_"
                    end
                    # puts team.data_competitions
                    team.save
                end
            else
                puts "Error meet not found: " + spl[0]
            end
        end
        puts "END"
        currentMeet.save

        currentMeet = nil
        # for Events with DETAILS
        File.read("#{Rails.root}/app/data/gameresults/ftc-data/1617velv-FULL-MatchResultsDetails.csv").each_line do |line|
            if line.include?("Red1,Red2")
                next
            end
            spl = line.split(",")
            tournname = spl[0].split("-")[1] + "-" + spl[0].split("-")[2]
            if(!currentMeet or currentMeet.ftcmatchcode != tournname)
                meet = Event.where(ftcmatchcode:tournname).first
                if(currentMeet)
                    currentMeet.save
                end
                puts "Meet #{meet.id}"
                currentMeet = meet
            end
            if(currentMeet != nil)
                currentMeet.advanceddata = true
                if(currentMeet.data_competition.length == 0)
                    currentMeet.data_competition = "#{spl[1]},#{spl[3,6].join(",")},#{spl[9,6].join(",")},#{spl[15,6].join(",")}"
                else
                    currentMeet.data_competition = currentMeet.data_competition + "|#{spl[1]},#{spl[3,6].join(",")},#{spl[9,6].join(",")},#{spl[15,6].join(",")}"
                end
                # Red first
                teams = []
                for teamid in spl[3,6]
                    if(Team.exists?(teamid))
                        teams.push(Team.find(teamid))
                    end
                end
                for team in teams
                    if(team == nil)
                        next
                    end
                    if(team.data_competitions.include?("#{meet.id}_"))
                        next
                    end
                    if(team.data_competitions.length == 0)
                        team.data_competitions = "#{meet.id}_"
                    else
                        team.data_competitions += "|#{meet.id}_"
                    end
                    # puts team.data_competitions
                    team.save
                end
                # meet.save
            else
                puts "Error meet not found: " + spl[0]
            end
        end
        currentMeet.save
        puts "ADVANCED DONE"

        # for team in Team.all
        #     team.save
        # end
    end
end
