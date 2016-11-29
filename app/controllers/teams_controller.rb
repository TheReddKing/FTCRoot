class TeamsController < ApplicationController
    def index

    end
    def initialize
        super # this calls ActionController::Base initialize
    end
    def map
        @hello = Array.new
        puts "SHOWING TEAMS"
        File.read("#{Rails.root}/app/data/teamdata.txt").each_line do |line|
            @hello.append(Team.new(JSON.parse(line)))
        end
    end
    Quanda = Struct.new :id, :title, :question
    def search
        puts params[:q]
        @results = Array.new
        if params[:q]
            puts "SEARCHING"
            index = Picky::Index.new :quandas do
                indexing removes_characters: /[^\p{Alpha}\p{Blank}0-9]/i
                category :title
                category :question, partial: Picky::Partial::None.new
                indexing splits_text_on: /[\s<>]/
                # category :question
            #   category :name
            end
            i = 0
            array =  File.read("#{Rails.root}/app/data/forumanswers.txt").split("*-THEREDDKING-*")
            for line in array
                sp = line.split("*-1THEREDDKING-*")
                index.add Quanda.new(i,sp[0],sp[1])
                i += 1
            end
            array =  File.read("#{Rails.root}/app/data/forumanswers.txt").split("*-THEREDDKING-*")
            searcher = Picky::Search.new index
            results = searcher.search params[:q]
            for ele in results.ids
                @results.append array[ele].split("*-1THEREDDKING-*")[1]
            end
            # puts results.ids
        end
    end
    def show
    end
    def twitter
    end
    def nothing
        send_data(Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="), :type => "image/gif", :disposition => "inline")
    end
end
