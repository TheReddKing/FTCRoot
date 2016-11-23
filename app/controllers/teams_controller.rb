class TeamsController < ApplicationController
    def index

    end
    def map
        @hello = Array.new
        puts "HI"
        File.read("#{Rails.root}/app/data/teamdata.txt").each_line do |line|
            @hello.append(Team.new(JSON.parse(line)))
        end
    end
    def search
        puts "HIIIII"
    end
    def show
    end
    def twitter
    end
end
