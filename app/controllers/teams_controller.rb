class TeamsController < ApplicationController
    def index
        @books = Book.all
    end
    def map
        @hello = Array.new
        puts "HI"
        File.read("#{Rails.root}/app/data/teamdata.txt").each_line do |line|
          # name: "Angela"    job: "Writer"    ...
          @hello.append(Team.new(JSON.parse(line)))
        #   data = line.split(/\|/)
        #   name, job = data.map{|d| d.split(": ")[1] }.flatten
        end
        # jason = {'id':"2000",'name':"HI","location":"THIS PLACE","latlong":["-20","30"]}
        # @hello.append(Team.new(jason))
    end
    def show

    end
end
