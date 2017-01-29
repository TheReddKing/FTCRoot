class VisitorsController < ApplicationController
    def sitemap
        @teams = Team.all #we are generating url's for posts
        @meets = Event.all #we are generating url's for posts
        respond_to do |format|
         format.xml
        end
    end
    def index
        @hello = Team.all
    end
end
