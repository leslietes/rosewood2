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
    @rooms     = Room.unoccupied
    @occupants = Occupant.waiting_for_room
    # for checkboxes
    @basic = Utility.basic
    @extra = Utility.extras
    
    return unless request.post?
    
    # at least one occupant should be selected
    if params[:occupants].blank? || params[:room_no].blank?
      flash[:notice] = "Please select room and occupant"
      redirect_to :back
    end
    
    if Room.exists?(params[:room_no])
      Room.transaction do
        checkin = new_checkin(params[:room_no],params[:start_date]) 
        add_occupants(checkin, params[:occupants], params[:start_date])
        add_utilities(checkin,params[:utilities],  params[:start_date])
        occupy_room(params[:room_no]) 
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
        html = render_to_string(:layout => false, :action => "occupancy_list_print.html.erb")
        # many other options
        kit  = PDFKit.new(html, :page_size =>   'Letter')
        # you have to give whole path of stylesheet
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/print.css"
        # use disposition inline to open in browser. if removed, will automatically download. Another option is 'inline'
        send_data kit.to_pdf, filename: "occupancy_list_#{Date.today}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end
  
  def occupancy_details
    #todo: check if checkin exists else redirect    
    @checkin   = Checkin.get_details(params[:id])
    @details   = @checkin.first.checkin_details
    
    # for form
    @occupants = Occupant.waiting_for_room
    @utilities = Utility.all.flatten - @checkin.first.utilities.flatten
    
    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(:layout => false, :action => "occupancy_details.html.erb")
        kit = PDFKit.new(html, :page_size => 'Letter')
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/print.css"
        send_data kit.to_pdf, filename: "occupancy_details_#{@checkin.first.room_no}_#{Date.today}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end
  
  def new_roommate
    if params[:occupants].blank? && params[:utilities].blank?
      flash[:notice] = "Please select new roommate or utility to add"
      redirect_to occupancy_details_room_url() 
      return
    end
    
    checkin = Checkin.find(params[:id])
    
    add_occupants(checkin, params[:occupants], params[:start_date]) if !params[:occupants].blank?
    add_utilities(checkin, params[:utilities], params[:start_date]) if !params[:utilities].blank?
    
    flash[:notice] = "New roommate or utility added"
    redirect_to occupancy_details_room_url()
  end
  
  def remove_occupant
    occupant = CheckinOccupant.find(params[:id])
    occupant.vacate_room!
    
    flash[:notice] = "Occupant has vacated room"
    redirect_to occupancy_details_room_url(occupant.checkin.id)
  end
  
  def remove_utility
    detail = CheckinDetail.find(params[:id])
    detail.remove!
    
    flash[:notice] = "Utility was removed from room"
    redirect_to occupancy_details_room_url(detail.checkin.id)
  end
  
  def vacate
    checkin = Checkin.find(params[:id])
    
    Checkin.transaction do
      checkin.vacate!
      checkin.checkin_occupants.each do |checkin_occupant| 
        checkin_occupant.vacate_room!
        checkin_occupant.occupant.inactive! 
      end
      vacate_room(checkin.room_id)
    end
    
    flash[:notice] = "Room has been vacated"
    redirect_to occupancy_list_rooms_url
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:room_no,:max_occupants,:daily_rate,:room_rate,:active,:occupied)
    end
    
    def new_checkin(room_id, start_date)
      Checkin.create(room_id: room_id, start_date: start_date, user_id: current_user.id)
    end
      
    def occupy_room(room_id)      
      Room.occupied!(room_id)
    end
    
    def vacate_room(room_id)
      Room.vacated!(room_id)
    end
    
    def add_occupants(checkin, occupants, start_date)
      occupants.each do |occupant_id|
        checkin.checkin_occupants.create(id: checkin, occupant_id: occupant_id, start_date: start_date)
        Occupant.checked_in!(occupant_id)
      end
    end
    
    def add_utilities(checkin, utilities_array, start_date)
      return if utilities_array.blank?
      
      # returns ["1","2"]
      keys = utilities_array.keys
      
      keys.each do |key| 
        # get updated amount
        amount = Utility.find(key).rate
        checkin.checkin_details.create(utility_id: key, amount: amount, start_date: start_date)
      end
    end    
end
