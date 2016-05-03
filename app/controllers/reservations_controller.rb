class ReservationsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @reservation = Reservation.new
    @room = Room.find(params[:room_id])
  end
  
  def create
    @room = Room.find(params[:room_id])
    @reservation = @room.build_reservation(reservation_params)
    @reservation.user_id = current_user.id
    
    respond_to do |format|
      if @reservation.save
        format.html { redirect_to room_reservation_url(@room.id,@reservation.id), notice: 'Reservation was successfully created'}
      else
        format.html { render :new }
      end
    end
  end
  
  def edit
    @room = Room.find(params[:room_id])
    @reservation = @room.reservation
  end
  
  def update
    @room = Room.find(params[:room_id])
    @reservation = @room.reservation
    @reservation.user_id = current_user.id
    
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to room_reservation_url, notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show
    @room = Room.find(params[:room_id])
    @reservation = @room.reservation
  end
  
  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to vacancies_rooms_url, notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def reservation_params
    params.require(:reservation).permit(:movein_date,:name,:room_id,:user_id)
  end
end
