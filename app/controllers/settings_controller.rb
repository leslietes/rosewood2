class SettingsController < ApplicationController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /settings
  # GET /settings.json
  #def index
  #  @settings = Setting.all
  #end

  # GET /settings/1
  # GET /settings/1.json
  def show
  end

  # GET /settings/new
  #def new
  #  @setting = Setting.new
  #end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings
  # POST /settings.json
  def create
    @setting = Setting.new(setting_params)

    respond_to do |format|
      if @setting.save
        format.html { redirect_to setting_url, notice: 'Setting was successfully created.' }
        format.json { render :show, status: :created, location: @setting }
      else
        format.html { render :new }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to setting_url, notice: 'Settings were successfully updated.' }
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to settings_url, notice: 'Setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.first || Setting.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      #params.fetch(:setting, {})
      params.require(:setting).permit(:logo, :address, :phone, :mobile, :email, :page_description, :photo1, :photo1_caption, :photo2, :photo2_caption, :photo3, :photo3_caption, :photo4, :photo4_caption, :photo5, :photo5_caption,
      :about_us, :why_us_1, :whyus1, :why_us_2, :whyus2, :why_us_3, :whyus3)
      
    end
end
