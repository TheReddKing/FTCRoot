class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
      @events = if params[:search] != nil
                  Event.where('lower(location) LIKE lower(?) or lower(name) LIKE lower(?) or date LIKE ?', "#{params[:search]}%", "%#{params[:search]}%","%#{params[:search]}%")
              else
                  Event.all
              end
    @events = @events.where("advanceddata is not null")
      if(ActiveRecord::Base.connection.adapter_name == 'Mysql2' )
          @events = @events.order( 'STR_TO_DATE(date, "%m/%d/%Y") DESC, name ASC' ).paginate(:page => params[:page], :per_page => 20)
      else
          @events = @events.order( 'to_date(date,\'MM/DD/YYYY\') DESC, name ASC' ).paginate(:page => params[:page], :per_page => 20)
      end
  end

  # GET /events/1
  # GET /events/1.json
  def show
      if(!params[:name])
          respond_to do |format|
              format.html { redirect_to fullevent_path(:name=>@event.name.gsub(/[^A-Za-z0-9_ ]/,"").gsub(" ","_")) }
          end
          return
          # render :search
          # return
      end
      @event_events = []
      alldata = @event.data_competition.split("|")
      for c in alldata
          comp = c.split(',')
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
          if(@event.advanceddata)
              #dat = "#{event.redscore},#{event.redauto},#{event.redteleop},#{event.redend},#{event.redpenalty}"
              dat[:reddetails] = comp[7,6].join(",")
              dat[:bluedetails] = comp[13,6].join(",")
              dat[:redscore] = comp[7]
              dat[:bluescore] = comp[13]
          else
              dat[:reddetails] = ""
              dat[:bluedetails] = ""
              dat[:redscore] = comp[7]
              dat[:bluescore] = comp[8]
          end
          @event_events.push(dat)
      end
    #   FOR THE OTHER STATS
        statData = @event.data_stats.split("|")
        @event_stats = []
        @enableTitles = false;
        for t in statData
            dat = Hash.new
            team = t.split(",")
            dat[:id] = team[0]
            dat[:rank] = team[1]
            dat[:qp] = team[2]
            dat[:rp] = team[3]
            dat[:high] = team[4]
            dat[:elim] = team[6] + "  "
            if dat[:elim].length > 2
                @enableTitles = true;
            end
            @event_stats.push(dat)
        end
      # TournamentCode,   Num,    Name        ,R,QP,RP    ,High   ,MP ,Elim   ,WP,OPR,OPRm,

  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'League meet was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'League meet was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    # @event.destroy
    # respond_to do |format|
    #   format.html { redirect_to events_url, notice: 'League meet was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :description, :meetid)
    end
end
