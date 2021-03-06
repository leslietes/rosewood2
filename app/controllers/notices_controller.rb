class NoticesController < ApplicationController
  before_action :authenticate_user!
    
  def new
    @notice = Notice.new
    @checkin= Checkin.find(params[:checkin_id])
  end
  
  def create
    @checkin = Checkin.find(params[:checkin_id])
    @notice  = @checkin.build_notice(notice_params)
    @notice.user_id = current_user.id
    
    respond_to do |format|
      if @notice.save
        format.html { redirect_to checkin_notice_url(@checkin.id,@notice.id), notice: 'Notice to Vacate was successfully created'}
      else
        format.html { render :new }
      end
    end
  end
  
  def edit
    @checkin= Checkin.find(params[:checkin_id])
    @notice = @checkin.notice
  end
  
  def update
    @checkin= Checkin.find(params[:checkin_id])
    @notice = @checkin.notice
    @notice.user_id = current_user.id
    
    respond_to do |format|
      if @notice.update(notice_params)
        format.html { redirect_to checkin_notice_url, notice: 'Notice to Vacate was successfully updated.' }
        format.json { render :show, status: :ok, location: @notice }
      else
        format.html { render :edit }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show
    @checkin  = Checkin.find(params[:checkin_id])
    @occupants= @checkin.occupants.pluck(:first_name,:last_name)
    @notice   = @checkin.notice
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def notice_params
    params.require(:notice).permit(:moveout_date,:reason,:date_received,:reason,:notes,:checkin_id)
  end
end
