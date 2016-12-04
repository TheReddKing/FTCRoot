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

        File.read("#{Rails.root}/app/data/teamdata.txt").each_line do |line|
            ftcteam = FTCTeam.new(JSON.parse(line))
            # For testing purposes only
            # :name, :id, :location, :location_lat, :location_long
            team = Team.new(name: ftcteam.name, id: ftcteam.id, location: ftcteam.address, location_lat: ftcteam.lat.to_f, location_long: ftcteam.long.to_f)
            team.save
            if ftcteam.website
                team.team_assets.create(content: ftcteam.website, ctype: 'WEBSITE')
            end
        end

        meet = nil
        order = 1
        File.read("#{Rails.root}/app/data/gameresults.txt").each_line do |line|
            if line.include?('-THEREDDKING-')
                spl = line.split('-THEREDDKING-')
                meet = LeagueMeet.new(name: spl[1])
                meet.save
                order = 1
            else
                spl = line.split('|')
                splr = spl[2].split(",")
                splb = spl[3].split(",")
                event = meet.league_meet_events.create(order:order,
                redscore:splr[0],
                redauto:splr[1],
                redteleop:splr[2],
                redend:splr[3],
                redpenalty:splr[4],
                bluescore:splb[0],
                blueauto:splb[1],
                blueteleop:splb[2],
                blueend:splb[3],
                bluepenalty:splb[4])
                for teamn in spl[0].split(",")
                    event.league_meet_event_teams.create(teamid:teamn,alliance:"RED")
                end
                for teamn in spl[1].split(",")
                    event.league_meet_event_teams.create(teamid:teamn,alliance:"BLUE")
                end

                order += 1
            end
        end
    end
end
