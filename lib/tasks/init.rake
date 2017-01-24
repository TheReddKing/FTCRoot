# rails init:load
namespace :init do
    desc 'TODO'
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
    task updateM: :environment do
        File.read("#{Rails.root}/app/data/gameresults/ftc-data/1617velv-event-list.csv").each_line do |line|
            spl = line.split(',')
            region = Region.where(name:spl[2])[0]
            if(region == nil)
                region = Region.new(name:spl[2])
                region.save
            end
            meet = LeagueMeet.where(ftcmatchcode:spl[8])[0]
            if(meet == nil)
                meet = LeagueMeet.new(name: spl[1],date:spl[0],location:spl[2],ftcmatchcode:spl[8],competitiontype:spl[3],data_competition:"")
                meet.region = region
                meet.save
                region.save
            end
        end
        for meet in LeagueMeet.all
            meet.data_competition = ""
            meet.save
        end
        for team in Team.all
            team.data_competitions = ""
            team.data_strong = ""
            team.save
        end
        # For events with no details
        File.read("#{Rails.root}/app/data/gameresults/ftc-data/1617velv-FULL-MatchResults.csv").each_line do |line|
            if line.include?("Red0,Red1,Red2")
                next
            end
            spl = line.split(",")
            tournname = spl[0].split("-")[1]
            meet = LeagueMeet.where(ftcmatchcode:tournname).first
            if(meet != nil)
                meet.advanceddata = false
                if(meet.data_competition.length == 0)
                    meet.data_competition = "#{spl[1]},#{spl[3,8].join(",")}"
                else
                    meet.data_competition = meet.data_competition + "|#{spl[1]},#{spl[3,8].join(",")}"
                end
                meet.save
            else
                puts "Error meet not found: " + spl[0]
            end
        end

        # for Events with DETAILS
        File.read("#{Rails.root}/app/data/gameresults/ftc-data/1617velv-FULL-MatchResultsDetails.csv").each_line do |line|
            if line.include?("Red0,Red1,Red2")
                next
            end
            spl = line.split(",")
            tournname = spl[0].split("-")[1]
            meet = LeagueMeet.where(ftcmatchcode:tournname).first
            if(meet != nil)
                meet.advanceddata = true
                if(meet.data_competition.length == 0)
                    meet.data_competition = "#{spl[1]},#{spl[3,6].join(",")},#{spl[9,6].join(",")},#{spl[15,6].join(",")}"
                else
                    meet.data_competition = meet.data_competition + "|#{spl[1]},#{spl[3,6].join(",")},#{spl[9,6].join(",")},#{spl[15,6].join(",")}"
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
                meet.save
            else
                puts "Error meet not found: " + spl[0]
            end
        end

        # for team in Team.all
        #     team.save
        # end
    end
end
