class OccupantsController < ApplicationController
  before_action :set_occupant, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /occupants
  # GET /occupants.json
  def index
    @occupants = Occupant.all
  end

  # GET /occupants/1
  # GET /occupants/1.json
  def show
  end

  # GET /occupants/new
  def new
    @occupant = Occupant.new
  end

  # GET /occupants/1/edit
  def edit
  end

  # POST /occupants
  # POST /occupants.json
  def create
    @occupant = Occupant.new(occupant_params)

    respond_to do |format|
      if @occupant.save
        format.html { redirect_to @occupant, notice: 'Occupant was successfully created.' }
        format.json { render :show, status: :created, location: @occupant }
      else
        format.html { render :new }
        format.json { render json: @occupant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /occupants/1
  # PATCH/PUT /occupants/1.json
  def update
    respond_to do |format|
      if @occupant.update(occupant_params)
        format.html { redirect_to @occupant, notice: 'Occupant was successfully updated.' }
        format.json { render :show, status: :ok, location: @occupant }
      else
        format.html { render :edit }
        format.json { render json: @occupant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /occupants/1
  # DELETE /occupants/1.json
  def destroy
    @occupant.destroy
    respond_to do |format|
      format.html { redirect_to occupants_url, notice: 'Occupant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_occupant
      @occupant = Occupant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def occupant_params
      params.require(:occupant).permit(:first_name,:last_name,:address1,:address2,:city,:province,:postcode,:telephone,:mobile,:birthdate,:school_or_work,
      :course_or_position,:year_or_date_started,:previous_school_or_work,:school_city,:school_province,:course_and_year,:work_position,:date_left,:fathers_name,:fathers_address,
      :fathers_occupation,:fathers_company,:fathers_company_address,:fathers_telephone,:fathers_mobile,:mothers_name,:mothers_address,:mothers_occupation,:mothers_company,:mothers_company_address,
      :mothers_telephone,:mothers_mobile,:guardians_name,:guardians_address,:guardians_telephone,:guardians_mobile)
    end
end
