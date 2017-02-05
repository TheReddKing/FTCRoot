class RegionsController < ApplicationController
  before_action :set_region, only: [:show, :edit, :update, :destroy]

  # GET /regions
  # GET /regions.json
  def index
      @regions = Region.all.order("name ASC").paginate(:page => params[:page], :per_page => 15)
  end

  # GET /regions/1
  # GET /regions/1.json
  def show
      if(!params[:name])
          respond_to do |format|
              format.html { redirect_to fullregion_path(:name=>@region.name.gsub(/[^A-Za-z0-9_ ]/,"").gsub(" ","_")) }
          end
          return
          # render :search
          # return
      end
      @meets = @region.events.all
      @meets = @meets.where("advanceddata is not null")
      if(ActiveRecord::Base.connection.adapter_name == 'Mysql2' )
          @meets = @meets.order( 'STR_TO_DATE(date, "%m/%d/%Y") DESC, name ASC' ).paginate(:page => params[:page], :per_page => 15)
      else
          @meets = @meets.order( 'to_date(date,\'MM/DD/YYYY\') DESC, name ASC' ).paginate(:page => params[:page], :per_page => 15)
      end

      if @region.name
          @website = @region.name
          if @region.name.split(" ")[-1].upcase == @region.name.split(" ")[-1]
              @website = @region.name.split(" ")[0..-1]
          end
          @website = "http://ftcstats.org/"  + @website.gsub(" ","_").downcase + ".html"
      end
  end

  # GET /regions/new
  def new
    @region = Region.new
  end

  # GET /regions/1/edit
  def edit
  end

  # POST /regions
  # POST /regions.json
  def create
    @region = Region.new(region_params)

    respond_to do |format|
      if @region.save
        format.html { redirect_to @region, notice: 'Region was successfully created.' }
        format.json { render :show, status: :created, location: @region }
      else
        format.html { render :new }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /regions/1
  # PATCH/PUT /regions/1.json
  def update
    respond_to do |format|
      if @region.update(region_params)
        format.html { redirect_to @region, notice: 'Region was successfully updated.' }
        format.json { render :show, status: :ok, location: @region }
      else
        format.html { render :edit }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /regions/1
  # DELETE /regions/1.json
  def destroy
    @region.destroy
    respond_to do |format|
      format.html { redirect_to regions_url, notice: 'Region was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_region
      @region = Region.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def region_params
      params.require(:region).permit(:name, :website, :info)
    end
end
