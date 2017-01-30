class ToolsController < ApplicationController

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
    def stats
        allEvents = Event.all
        @allScores = []
        allEvents.each do |com|
            alldata = com.data_competition.split("|")
            for c in alldata
                comp = c.split(",")
                    # puts c
                dat = Hash.new
                dat[:name] = comp[0]
                if comp[3].to_i == 0
                    dat[:redteam] = comp[1,2]
                    dat[:blueteam] = comp[4,2]
                    dat[:numteams] = 3
                else
                    dat[:redteam] = comp[1,3]
                    dat[:blueteam] = comp[4,3]
                    dat[:numteams] = 2
                end
                if(com.advanceddata)
                    #dat = "#{event.redscore},#{event.redauto},#{event.redteleop},#{event.redend},#{event.redpenalty}"
                    dat[:reddetails] = comp[7,6].join(",")
                    dat[:bluedetails] = comp[13,6].join(",")
                    dat[:redscore] = (comp[7].to_i - comp[12].to_i)
                    dat[:bluescore] = (comp[13].to_i - comp[18].to_i)

                    if(dat[:redscore].to_i > dat[:bluescore].to_i)
                        # Red
                        dat[:ownscore] = dat[:redscore]
                        dat[:oppscore] = dat[:bluescore]
                        dat[:ownteam] = dat[:redteam]
                        dat[:owndetails] = dat[:reddetails]
                        dat[:oppdetails] = dat[:bluedetails]
                        dat[:owncolor] = "red"
                    else
                        dat[:ownscore] = dat[:bluescore]
                        dat[:ownteam] = dat[:blueteam]
                        dat[:oppscore] = dat[:redscore]
                        dat[:owndetails] = dat[:bluedetails]
                        dat[:oppdetails] = dat[:reddetails]
                        dat[:owncolor] = "blue"
                    end
                    dat[:event] = com
                    @allScores.push(dat)
                end

            end
            # @allScores = @allScores.sort_by { |s| [-s[:ownscore].to_i,-s[:oppscore].to_i] }
            @allScores = @allScores.sort { |a,b| a[:ownscore].to_i > b[:ownscore].to_i ? -1 : (a[:ownscore].to_i < b[:ownscore].to_i ? 1 : (a[:ownscore].to_i <=> b[:ownscore].to_i)) }
            @allScores = @allScores.first(20)
        end
        # .order("greatest(redscore-redpenalty,bluescore-bluepenalty) DESC").where.not(:redauto => "-1").first(20)
    end
    def index

    end
    def initialize
        super # this calls ActionController::Base initialize
    end
    def map
        @hello = Team.all
        puts "SHOWING TEAMS"

    end
    Quanda = Struct.new :id, :title, :question
    def search
        puts params[:q]
        @keywords = Array.new
        @results = Array.new
        if params[:q]
            @keywords = params[:q].split( /[<>\s\/\-\_\:\"\&\/]/)
            puts "SEARCHING"
            index = Picky::Index.new :quandas do
                indexing removes_characters: /[^\p{Alpha}\p{Blank}0-9]/i,splits_text_on: /[\<\>\s\/\-\_\:\"\&\/]/,
                substitutes_characters_with:        Picky::CharacterSubstituters::WestEuropean.new,
                stems_with:                         Lingua::Stemmer.new

                category :title, partial:    Picky::Partial::Substring.new(:from => 1)
                category :question, partial: Picky::Partial::Substring.new(:from => 3)
                # category :question
            #   category :name
            end
            i = 0

            #FOR EASY SEARCHING             &lt;[^0-9\<h]*(1|2)(?=&gt;)
            #REPLACE WITH                   $&&gt;$&g
            array = File.read("#{Rails.root}/app/data/forumanswers.txt").split("*-THEREDDKING-*")
            unique = []
            stuff = HTMLEntities.new
            for line in array
                sp = line.split("*-1THEREDDKING-*")
                if !unique.include?(sp[0])
                    # print ActionView::Base.full_sanitizer.sanitize(sp[1])
                    index.add Quanda.new(i,stuff.decode(sp[0]),stuff.decode(ActionView::Base.full_sanitizer.sanitize(sp[1])))
                end
                unique.append(sp[0])
                i += 1
            end
            # FOR RULES                     \<[^0-9\<h]*(1|2)(?=\>)
            # REPLACE width                 $&>$&g
            rules = File.read("#{Rails.root}/app/data/rules.txt").split("\n")
            rules.each_with_index do |line, ind|
                if(line.length == 0)
                    next
                end
                sp = line.split("*-1THEREDDKING-*")
                if !unique.include?(sp[0])
                    index.add Quanda.new(i,"DEFINITION: " + sp[0],sp[0] + " " + sp[1])
                    rules[ind] = sp[0] + "*-1THEREDDKING-*<h2>DEFINITION: " + CGI::escapeHTML(sp[0]) + "</h2><div class='postcontent'>" + sp[1] + "</div>"
                end
                unique.append(sp[0])
                i += 1
            end
            array += rules
            searcher = Picky::Search.new index
            results = searcher.search params[:q]
            for ele in results.ids.uniq
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
