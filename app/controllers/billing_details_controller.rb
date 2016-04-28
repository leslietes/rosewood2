class BillingDetailsController < ApplicationController
  #before_action :set_billing, only: [:index, :show, :edit, :update, :destroy]
  before_action :authenticate_user!
  
  def index
    @billing = Billing.find(params[:billing_id])
    @billing_details= @billing.billing_details.includes(:billing_utilities,:checkin => {:checkin_occupants => :occupant})
    
    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(:layout => false, :action => "index.html.erb")
        # many other options
        kit  = PDFKit.new(html, :page_size =>   'Letter')
        # you have to give whole path of stylesheet
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/print.css"
        # use disposition inline to open in browser. if removed, will automatically download. Another option is 'inline'
        send_data kit.to_pdf, filename: "billing_statements_#{Date.today}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end
  
  def show
    @billing = Billing.find(params[:billing_id])
    @billing_detail= @billing.billing_details.where(params[:id]).includes(:billing_utilities,:checkin => {:checkin_occupants => :occupant})
    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(:layout => false, :action => "show.html.erb")
        # many other options
        kit  = PDFKit.new(html, :page_size =>   'Letter')
        # you have to give whole path of stylesheet
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/print.css"
        # use disposition inline to open in browser. if removed, will automatically download. Another option is 'inline'
        send_data kit.to_pdf, filename: "billing_statements_#{Date.today}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end
  
  def edit
    @billing = Billing.find(params[:billing_id])
    @billing_detail = BillingDetail.where(id: params[:id]).includes(:billing_utilities,:checkin => {:checkin_occupants => :occupant})
    @utilities      = Utility.all.pluck(:name,:id)
  end
  
  def update
    respond_to do |format|
      if BillingUtility.update(params['utilities'].keys, params['utilities'].values)
        format.html { redirect_to billing_billing_details_url(params[:billing_id]), notice: 'Billing was successfully updated.' }
        format.json { render :show, status: :ok, location: @billing_detail }
      else
        format.html { render :edit }
        format.json { render json: @billing_detail.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @billing_detail.billing_utilities.destroy
    respond_to do |format|
      format.html { redirect_to @billing_detail, notice: 'Billing Detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def add_billing_utilities
    return unless request.post?
    
    if params[:new_billing_utility].blank?
      flash[:notice] = "Please select extras to add"
    else
      billing_detail = BillingDetail.find(params[:id])
      billing_detail.add_billing_utility(params[:new_billing_utility], current_user.id)
      flash[:notice] = "Additional billing charges added successfully"
    end
    
    redirect_to edit_billing_billing_detail_url(params[:billing_id],params[:id])
  end
  
  def remove_billing_utilities
    utility = BillingUtility.find(params[:id])
    utility.destroy
    
    flash[:notice] = "Billing Utility was successfully destroyed."
    
    redirect_to edit_billing_billing_detail_url(params[:billing_id],params[:billing_details_id])
  end
  
  def print_admin_copy
    @billing = BillingDetail.find(params[:billing_id]).billing
    @details = BillingDetail.find_by_sql("select billing_details.id, 
                                                 billing_details.room_no, 
                                                 billing_details.checkin_id, 
                                                 checkin_occupants.occupant_id,
                                                 occupants.first_name,
                                                 occupants.last_name,
                                                 (select billing_utilities.amount 
                                                    from billing_utilities 
                                                   where billing_utilities.billing_detail_id = billing_details.id and 
                                                         utility_name = 'Room Rate') as room,
                                                 (select billing_utilities.amount 
                                                    from billing_utilities 
                                                   where billing_utilities.billing_detail_id = billing_details.id and 
                                                         utility_name = 'Electricity') as electricity,              
                                                 (select billing_utilities.amount 
                                                    from billing_utilities 
                                                   where billing_utilities.billing_detail_id = billing_details.id and 
                                                         utility_name = 'Water') as water,
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
                                                         utility_name = 'Parking') as parking,
                                                 (select billing_utilities.amount 
                                                    from billing_utilities 
                                                   where billing_utilities.billing_detail_id = billing_details.id and 
                                                         utility_name = 'Cleaning Fees') as cleaning,         
                                                 (select billing_utilities.amount 
                                                    from billing_utilities 
                                                   where billing_utilities.billing_detail_id = billing_details.id and 
                                                         utility_name = 'Transcient') as transcient,
                                                 (select billing_utilities.amount 
                                                    from billing_utilities 
                                                   where billing_utilities.billing_detail_id = billing_details.id and 
                                                         utility_name = 'Cable TV Termination') as penalty,
                                                 (select billing_utilities.amount 
                                                    from billing_utilities
                                                   where billing_utilities.billing_detail_id = billing_details.id and 
                                                         utility_name = 'Damages') as damages
                                                
                                                    from billing_details,
                                                         checkin_occupants,
                                                         occupants
                                           where billing_details.checkin_id = checkin_occupants.checkin_id and
                                                 checkin_occupants.occupant_id = occupants.id and
                                                 billing_details.billing_id = #{params[:billing_id]};")
    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(:layout => false, :action => "print_admin_copy.html.erb")
        # many other options
        kit  = PDFKit.new(html, :page_size =>   'Letter')
        # you have to give whole path of stylesheet
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/print.css"
        # use disposition inline to open in browser. if removed, will automatically download. Another option is 'inline'
        send_data kit.to_pdf, filename: "billing_#{Date.today}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end
  
  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_billing
    
  end  
end
