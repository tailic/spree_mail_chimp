class Spree::SubscriptionsController < Spree::BaseController

  def mailchimp
    @mailchimp ||= Mailchimp::API.new(Spree::Config.get(:mailchimp_api_key))
  end

  def create
    @errors = []

    if params[:email].blank?
      @errors << Spree.t('missing_email')
    elsif params[:email] !~ /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
      @errors << Spree.t('invalid_email_address')
    else
      begin
        @mc_member = mailchimp.lists.member_info(Spree::Config.get(:mailchimp_list_id), [ {'email' => params[:email] } ])["success_count"] >= 1
      rescue Mailchimp::Error => e
      end

      if @mc_member
        @errors << Spree.t('that_address_is_already_subscribed')
      else
        begin
         mailchimp.lists.subscribe(
            Spree::Config.get(:mailchimp_list_id),
            {'email' => params[:email]},
            {'FNAME' => params[:fname], 'LNAME' => params[:lname], 'MMERGE3' => params[:mmerge3]},
            true,
            true,
            Spree::Config.get(:mailchimp_send_welcome)
          )
        rescue Mailchimp::Error => e
          @errors << t('invalid_email_address')
        end
      end
    end

    flash[:error] = Spree.t(@errors) if @errors.present?
    flash[:success] = 'Sie haben einen Link zur Bestätigung Ihrer Anmeldung per E-Mail erhalten.' if @errors.empty?
    redirect_to :back

  end
end
