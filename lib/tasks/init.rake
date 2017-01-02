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
                    team = Team.new(name: ftcteam.name, id: ftcteam.id, location: ftcteam.address, location_lat: ftcteam.lat.to_f, location_long: ftcteam.long.to_f,website:ftcteam.website)
                    team.save
                end
            end
        end
    end
    task migrate: :environment do
        meet = nil
        order = 1
        files = Dir["#{Rails.root}/app/data/parsedgameresults/*.txt"]
        for file in files
            if(EventMigration.where(name:file.split("/")[-1].split("-")[0]).length > 0)
                next
            end
            File.read(file).each_line do |line|
                if line.include?('-THEREDDKING-')
                    spl = line.split(',')
                    region = Region.where(name:spl[3])[0]
                    if(region == nil)
                        region = Region.new(name:spl[3])
                        region.save
                    end
                    meet = LeagueMeet.new(name: spl[1],date:spl[2].split(" ")[0],location:spl[3])
                    meet.region = region
                    meet.save
                    region.save

                    order = 1
                else
                    spl = line.split('|')
                    splr = spl[3].split(",")
                    splb = spl[4].split(",")
                    event = meet.league_meet_events.create(name:spl[0],order:order,
                    redscore:splr[0],
                    redauto:splr[1],
                    redteleop:splr[2],
                    redend:splr[3],
                    redpenalty:splr[4],
                    bluescore:splb[0],
                    blueauto:splb[1],
                    blueteleop:splb[2],
                    blueend:splb[3],
                    bluepenalty:splb[4],

                    red1:spl[1].split(",")[0],
                    red2:spl[1].split(",")[1],
                    blue1:spl[2].split(",")[0],
                    blue2:spl[2].split(",")[1])
                    # for teamn in spl[1].split(",")
                    #     event.league_meet_event_teams.create(teamid:teamn,alliance:"RED")
                    # end
                    # for teamn in spl[2].split(",")
                    #     event.league_meet_event_teams.create(teamid:teamn,alliance:"BLUE")
                    # end

                    order += 1
                end
            end
            migrate = EventMigration.new(name:file.split("/")[-1].split("-")[0],migration_date:file.split("/")[-1].split("-")[1].split(".")[0])
            migrate.save
        end

    end
end
