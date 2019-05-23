class CheckinsController < ApplicationController
  before_action :authenticate_user!

  def index
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

  def print
    @rooms = Room.occupancy_list
    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(:layout => false, :action => "print.html.erb")
        # many other options
        kit  = PDFKit.new(html, :page_size =>   'Letter')
        # you have to give whole path of stylesheet
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/print.css"
        # use disposition inline to open in browser. if removed, will automatically download. Another option is 'inline'
        send_data kit.to_pdf, filename: "Occupancy List #{Date.today}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  def show
    #todo: check if checkin exists else redirect
    @checkin   = Checkin.get_details(params[:id])
    @details   = @checkin.first.checkin_details

    # for transfer room
    @rooms     = Room.unoccupied

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

  def new
    @checkin   = Checkin.new

    @rooms     = Room.unoccupied
    @occupants = Occupant.waiting_for_room
    # for checkboxes
    @basic = Utility.basic
    @extra = Utility.extras
  end

  def create
    @rooms     = Room.unoccupied
    @occupants = Occupant.waiting_for_room
    # for checkboxes
    @basic = Utility.basic
    @extra = Utility.extras

    # at least one occupant should be selected
    if params[:occupants].blank? || params[:room_no].blank? || params[:start_date].blank?
      flash[:notice] = "Room number, occupants and start date needs to be selected"
      render :new
      return
    end

    if Room.exists?(params[:room_no])
      Room.transaction do
        checkin = new_checkin(params[:room_no],params[:start_date])
        add_occupants(checkin, params[:occupants], params[:start_date])
        add_utilities(checkin,params[:utilities],  params[:room_no], params[:start_date])
        occupy_room(params[:room_no])
      end
      flash[:notice] = "Occupant has checked in"
      redirect_to new_checkin_url
    else
      flash[:notice]  = "Unable to check in. Please select valid room or occupant"
      render :new
    end
  end

  def new_roommate
    if params[:start_date].blank? || (params[:occupants].blank? && params[:utilities].blank?)
      flash[:notice] = "Occupants or utilities AND start date needs to be selected"
      redirect_to checkin_url(params[:id])
      return
    end

    checkin = Checkin.find(params[:id])

    add_occupants(checkin, params[:occupants], params[:start_date]) if !params[:occupants].blank?
    add_utilities(checkin, params[:utilities], checkin.room_id, params[:start_date]) if !params[:utilities].blank?

    flash[:notice] = "New roommate or utility added"
    redirect_to checkin_url(checkin)
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
    redirect_to checkins_url
  end

  def transfer
    if !params[:new_room_id].blank?

      checkin = Checkin.find(params[:id])

      Checkin.transaction do
        checkin.transfer_room(params[:new_room_id])
        Room.vacated!(params[:room_id])
        Room.occupied!(params[:new_room_id])
      end

      flash[:notice] = "Room transfer was made successfully"
    else
      flash[:notice] = "Room number not selected"
    end

    redirect_to checkin_url(params[:id])
  end

  def remove_occupant
    occupant = CheckinOccupant.find(params[:id])
    occupant.vacate_room!

    flash[:notice] = "Occupant has vacated room"
    redirect_to checkin_url(occupant.checkin.id)
  end

  def remove_utility
    detail = CheckinDetail.find(params[:id])
    detail.remove!

    flash[:notice] = "Utility was removed from room"
    redirect_to checkin_url(detail.checkin.id)
  end

  private

  def new_checkin(room_id, start_date)
    # get room no for easier generation of billings
    room_no = Room.room_no(room_id)
    Checkin.create(room_id: room_id, room_no: room_no, start_date: start_date, user_id: current_user.id)
  end

  def add_occupants(checkin, occupants, start_date)
    occupants.each do |occupant_id|
      checkin.checkin_occupants.create(id: checkin, occupant_id: occupant_id, start_date: start_date, user_id: current_user.id)
      Occupant.checked_in!(occupant_id)
    end
  end

  def add_utilities(checkin, utilities_array, room_id, start_date)
    return if utilities_array.blank?

    utilities_array.each do |key|
      # get room rate
      if key == "1"
        amount = Room.room_rate(room_id)
      else
        amount = Utility.find(key).first_rate
      end

      checkin.checkin_details.create(utility_id: key, amount: amount, start_date: start_date, amount: amount, user_id: current_user.id)
    end
  end

  def occupy_room(room_id)
    Room.occupied!(room_id)
  end

  def vacate_room(room_id)
    Room.vacated!(room_id)
  end
end
