class Team
    attr_accessor :id, :name, :address, :latlong, :website
    def initialize(jason)
        puts jason
        @id = jason['id']
        @name = jason['name']
        @address = jason['address']
        @latlong = jason['latlong']
        @website = jason['website']
    end
    def lat; latlong[0].to_s; end
    def long; latlong[1].to_s; end
end
