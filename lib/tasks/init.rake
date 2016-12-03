namespace :init do
  desc "TODO"
  task loadteamdata: :environment do
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
          def lat; latlong[0].to_s; end
          def long; latlong[1].to_s; end
      end

      File.read("#{Rails.root}/app/data/teamdata.txt").each_line do |line|
          ftcteam = FTCTeam.new(JSON.parse(line))
          # For testing purposes only
          # :name, :id, :location, :location_lat, :location_long
          team = Team.new(:name=>ftcteam.name,:id=>ftcteam.id,:location=>ftcteam.address,:location_lat=>ftcteam.lat.to_f,:location_long=>ftcteam.long.to_f)
          team.save
          if(ftcteam.website)
              team.team_assets.create(:content=> ftcteam.website, :ctype=>'WEBSITE')
          end
      end
  end

end
