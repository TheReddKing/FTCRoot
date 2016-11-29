class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  
    # def initialize
    #     super # this calls ActionController::Base initialize
    #     # print "SUPER INIT"
    # end
end
