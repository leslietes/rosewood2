class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to rooms_url, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to rooms_url, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def check_in
    @rooms     = Room.not_full
    @occupants = Occupant.waiting_for_room
    
    return unless request.post?
    
    if Room.exists?(params[:room_no]) && Occupant.exists?(params[:occupant])
      Room.transaction do
        new_checkin(params[:room_no], params[:occupant], params[:start_date]) 
        update_room(params[:room_no], params[:full]) 
        update_occupant(params[:occupant])
      end
      redirect_to check_in_rooms_url
      flash[:notice] = "Occupant has checked in"
    else
      flash[:error]  = "Unable to check in. Please select valid room or occupant"
    end
  end
  
  def occupancy_list
    @rooms = Room.occupancy_list
    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(:layout => false, :action => "occupancy_list.html.erb")
        # many other options
        kit  = PDFKit.new(html, :page_size =>   'Letter')
        # you have to give whole path of stylesheet
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/print.css"
        # use disposition inline to open in browser. if removed, will automatically download. Another option is 'inline'
        send_data kit.to_pdf, filename: "occupancy_list_#{Date.today}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:room_no,:max_occupants,:daily_rate,:room_rate,:active)
    end
    
    def new_checkin(room_id, occupant_id, start_date)
      Checkin.create(room_id: room_id, occupant_id: occupant_id, start_date: start_date)
    end
    
    def update_room(room_id, full_flag)
      Room.update_status(room_id, full_flag)
    end
    
    def update_occupant(occupant_id)
      Occupant.not_waiting(occupant_id)
    end
    
end
