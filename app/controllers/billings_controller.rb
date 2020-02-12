class BillingsController < ApplicationController
  before_action :set_billing, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /billings
  # GET /billings.json
  def index
    @billings = Billing.all.order(created_at: :desc)
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

  def reports
    @billings = Billing.all
  end

  def occupancy_list
    @billing = Billing.find(params[:id])
    @billing_details= @billing.billing_details.includes(:checkin => {:checkin_occupants => :occupant})

    respond_to do |format|
      format.html
      format.csv { send_data @details.to_csv }
      format.xls
      format.pdf do
        html = render_to_string(:layout => false, :action => "occupancy_list.html.erb")
        # many other options
        kit  = PDFKit.new(html, :page_size =>   'A4')
        # you have to give whole path of stylesheet
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/print.css"
        # use disposition inline to open in browser. if removed, will automatically download. Another option is 'inline'
        send_data kit.to_pdf, filename: "occupancy_list_as_of_#{@billing.statement_date}.pdf", orientation: "Portrait", type: "application/pdf", disposition: "inline"
      end
    end
  end

  def print_summary
    @billing = BillingDetail.find(params[:id]).billing
    @details = BillingDetail.find_by_sql("select billing_details.id,
                                                 billing_details.room_no,
                                                 billing_details.checkin_id,
                                                 billing_occupants.occupant_id,
                                                 occupants.first_name,
                                                 occupants.last_name,
                                                 (select billing_utilities.amount
                                                    from billing_utilities
                                                   where billing_utilities.billing_detail_id = billing_details.id and
                                                         utility_name = 'Advance Room Rental') as room,
                                                 (select billing_utilities.amount
                                                    from billing_utilities
                                                   where billing_utilities.billing_detail_id = billing_details.id and
                                                         utility_name = 'Electricity') as electricity,
                                                 (select sum(billing_utilities.amount)
                                                    from billing_utilities
                                                   where billing_utilities.billing_detail_id = billing_details.id and
                                                         (utility_name = 'Water (excess)' or utility_name = 'Water (minimum)')) as water,
                                                 (select billing_utilities.amount
                                                    from billing_utilities
                                                   where billing_utilities.billing_detail_id = billing_details.id and
                                                         utility_name = 'Cable TV Installation') as installation,
                                                 (select billing_utilities.amount
                                                    from billing_utilities
                                                   where billing_utilities.billing_detail_id = billing_details.id and
                                                         utility_name = 'Cable TV Subscription') as subscription,
                                                 (select billing_utilities.amount
                                                    from billing_utilities
                                                   where billing_utilities.billing_detail_id = billing_details.id and
                                                         utility_name = 'Cable TV Termination') as termination,
                                                 (select billing_utilities.amount
                                                    from billing_utilities
                                                   where billing_utilities.billing_detail_id = billing_details.id and
                                                         utility_name = 'Basement Parking') as parking,
                                                 (select billing_utilities.amount
                                                    from billing_utilities
                                                   where billing_utilities.billing_detail_id = billing_details.id and
                                                         utility_name = 'Cleaning Fee') as cleaning,
                                                 (select billing_utilities.amount
                                                    from billing_utilities
                                                   where billing_utilities.billing_detail_id = billing_details.id and
                                                         utility_name = 'Transcient Fee') as transcient,
                                                 (select billing_utilities.amount
                                                    from billing_utilities
                                                   where billing_utilities.billing_detail_id = billing_details.id and
                                                         utility_name = 'Penalty') as penalty,
                                                 (select billing_utilities.amount
                                                    from billing_utilities
                                                   where billing_utilities.billing_detail_id = billing_details.id and
                                                         utility_name = 'Damages') as damages,
                                                 (select billing_utilities.amount
                                                    from billing_utilities
                                                   where billing_utilities.billing_detail_id = billing_details.id and
                                                         utility_name = 'Lost Key') as lost_key,
                                                 (select billing_utilities.amount
                                                    from billing_utilities
                                                   where billing_utilities.billing_detail_id = billing_details.id and
                                                         utility_name = 'Locked Out') as locked_out,
                                                (select billing_utilities.amount
                                                            from billing_utilities
                                                           where billing_utilities.billing_detail_id = billing_details.id and
                                                                 utility_name = 'Overage') as overage
                                                    from billing_details,
                                                         billing_occupants,
                                                         occupants
                                           where billing_details.id = billing_occupants.billing_detail_id and
                                                 billing_occupants.occupant_id = occupants.id and
                                                 billing_details.billing_id = #{params[:id]};")
    respond_to do |format|
      format.html
      format.csv { send_data @details.to_csv }
      format.xls
      format.pdf do
        html = render_to_string(:layout => false, :action => "print_summary.html.erb")
        # many other options
        kit  = PDFKit.new(html, :page_size =>   'Letter')
        # you have to give whole path of stylesheet
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/print.css"
        # use disposition inline to open in browser. if removed, will automatically download. Another option is 'inline'
        send_data kit.to_pdf, filename: "billing_#{Date.today}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  def final_billing
    @checkin = Checkin.find(params[:id])
    @billing = Billing.new

    return unless request.post?

    @billing = Billing.new(statement_date: params[:statement_date],
                                    room_month: params[:room_month],
                                     room_year: params[:room_year],
                               utilities_month: params[:utilities_month],
                                utilities_year: params[:utilities_year],
                                 final_billing: true,
                                       user_id: current_user.id )
      if @billing.valid?
        Billing.transaction do
          @billing.save
          @billing.generate_final_billing(@checkin.id,current_user.id)
        end
        redirect_to billing_billing_details_url(@billing.id), notice: 'Final Billing was successfully created.'
      else
        render :final_billing
      end


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing
      @billing = Billing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def billing_params
      params.require(:billing).permit(:statement_date,:advance_rent_period,:electricity_reading_period,:utilities_reading_period,:user_id)
    end

    def generate_electricity_amount(billing_utilities)
      billing_utilities.each { |utility| utility.calculate_electricity }
    end

    def generate_water_amount(billing_utilities)
      billing_utilities.each { |utility| utility.calculate_water }
    end

    def get_occupants
      @occupants = Occupant.all
    end
end
