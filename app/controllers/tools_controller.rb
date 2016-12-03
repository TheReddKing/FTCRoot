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
