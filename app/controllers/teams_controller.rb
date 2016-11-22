class TeamsController < ApplicationController
    def index
        @books = Book.all
    end
    def map
        @hello = "HELLO"
        puts "HI"
    end
    def show

        # @post=Post.find(params[:id])
    end
end
