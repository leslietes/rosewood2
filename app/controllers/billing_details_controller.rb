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
    @billing_detail = BillingDetail.where(id: params[:id]).includes(:billing_utilities,:checkin => {:checkin_occupants => :occupant})
    #@billing_detail= @billing.billing_details.where(params[:id]).includes(:billing_utilities,:checkin => {:checkin_occupants => :occupant})
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
    @occupants      = Occupant.add_to_billing_detail
  end

  def update
    respond_to do |format|
      if BillingUtility.update(params['utilities'].keys, params['utilities'].values)
        format.html { redirect_to billing_billing_detail_url(params[:billing_id], params[:id]), notice: 'Billing was successfully updated.' }
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

  def add_comments
    @billing = Billing.find(params[:billing_id])
    @billing_detail = BillingDetail.where(id: params[:billing_details_id]).first
    @billing_detail.comments = params[:add_comment]
    @billing_detail.save

    redirect_to billing_billing_details_url(params[:billing_id]), notice: 'Successfully added comments.'
  end

  def remove_billing_occupant
    occupant = BillingOccupant.find(params[:id])
    occupant.destroy

    flash[:notice] = "Occupant was successfully removed."

    redirect_to edit_billing_billing_detail_url(params[:billing_id],params[:billing_details_id])

  end

  def add_billing_occupant
    return unless request.post?

    if params[:occupant_id].blank?
      flash[:notice] = "Please select occupant to add"
    else
      billing_detail = BillingDetail.find(params[:id])
      billing_detail.add_billing_occupant(params[:occupant_id], current_user.id)
      flash[:notice] = "Additional billing charges added successfully"
    end

    redirect_to edit_billing_billing_detail_url(params[:billing_id],params[:id])
  end



  private

  # Use callbacks to share common setup or constraints between actions.
  def set_billing

  end
end
