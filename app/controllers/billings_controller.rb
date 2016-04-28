class BillingsController < ApplicationController
  before_action :set_billing, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /billings
  # GET /billings.json
  def index
    @billings = Billing.all
  end

  # GET /billings/1
  # GET /billings/1.json
  def show
    redirect_to billing_billing_details_url(@billing)
  end

  # GET /billings/new
  def new
    @billing = Billing.new
  end

  # GET /billings/1/edit
  def edit
  end

  # POST /billings
  # POST /billings.json
  def create
    @billing = Billing.new(billing_params)
    @billing.user_id = current_user.id
    
    respond_to do |format|
      if @billing.valid?
        Billing.transaction do
          @billing.save
          @billing.generate_billing_details(current_user.id)
        end
        format.html { redirect_to billing_billing_details_url(@billing), notice: 'Billing was successfully created.' }
        format.json { render :show, status: :created, location: @billing }
      else
        format.html { render :new }
        format.json { render json: @billing.errors, status: :unprocessable_entity }
      end
    end
    
  end

  # PATCH/PUT /billings/1
  # PATCH/PUT /billings/1.json
  def update
    @billing.user_id = current_user.id
    
    respond_to do |format|
      if @billing.update(billing_params)
        format.html { redirect_to billings_url, notice: 'Billing was successfully updated.' }
        #format.json { render :show, status: :ok, location: @billing }
      else
        format.html { render :edit }
        format.json { render json: @billing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billings/1
  # DELETE /billings/1.json
  def destroy
    @billing.destroy
    respond_to do |format|
      format.html { redirect_to billings_url, notice: 'Billing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def electricity_reading
    @details = BillingUtility.get_electricity(params[:id])
  
    return unless request.post?

    # update multiple records in one form
    if BillingUtility.update(params['utilities'].keys, params['utilities'].values)
      generate_electricity_amount(@details)
      flash[:notice] = "Electricity Reading successfully added"
      redirect_to billing_billing_details_url(params[:id])
    else
      render :electricity_reading
    end
  end
  
  def water_reading
    @utilities = BillingUtility.get_water(params[:id])
    
    return unless request.post?
    
    # update multiple records in one form
    if BillingUtility.update(params['utilities'].keys, params['utilities'].values)
      generate_water_amount(@utilities)
      flash[:notice] = "Water Reading successfully added"
      redirect_to billing_billing_details_url(params[:id])
    else
      render :water_reading
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing
      @billing = Billing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def billing_params
      params.require(:billing).permit(:room_month,:room_year,:utilities_month,:utilities_year,:user_id)
    end
    
    def generate_electricity_amount(billing_utilities)
      billing_utilities.each { |utility| utility.calculate_electricity }
    end
    
    def generate_water_amount(billing_utilities)
      billing_utilities.each { |utility| utility.calculate_water }
    end
end
