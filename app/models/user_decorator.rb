Spree::User.class_eval do

  before_create :mailchimp_add_to_mailing_list
  before_update :mailchimp_update_in_mailing_list, :if => :is_mail_list_subscriber_changed?

  private

  # Subscribes a user to the mailing list
  #
  # Returns ?
  def mailchimp_add_to_mailing_list
    if self.is_mail_list_subscriber?
      begin
        subscriber = mailchimp.lists.subscribe(mailchimp_list_id, {'email' => self.email},  mailchimp_merge_vars, 'html', *mailchimp_subscription_opts)
        logger.debug "Fetching new mailchimp subscriber info"
        self.mailchimp_subscriber_id = subscriber['euid'] if self.mailchimp_subscriber_id.blank?
      rescue Mailchimp::Error => e
        logger.warn "SpreeMailChimp: Failed to create contact in Mailchimp: #{e.message}"
      end
    end
  end

  # Removes the User from the Mailchimp mailing list
  #
  # Returns ?
  def mailchimp_remove_from_mailing_list
    if !self.is_mail_list_subscriber? && self.mailchimp_subscriber_id.present?
      begin
        # TODO: Get rid of those magic values. Maybe add them as Spree::Config options?
        mailchimp.lists.unsubscribe(mailchimp_list_id, {'email' => self.email})
        logger.debug "Removing mailchimp subscriber"
      rescue Mailchimp::Error => e
        logger.warn "SpreeMailChimp: Failed to remove contact from Mailchimp: #{e.message}"
      end
    end
  end

  # Updates Mailchimp
  #
  # Returns nothing
  # TODO: Update the user's email address in Mailchimp if it changes.
  #       Look at listMemberUpdate
  def mailchimp_update_in_mailing_list
    if self.is_mail_list_subscriber?
      mailchimp_add_to_mailing_list
    elsif !self.is_mail_list_subscriber?
      mailchimp_remove_from_mailing_list
    end
  end

  # Creates an instance of the mailchimp::API
  #
  # Returns mailchimp::API
  def mailchimp
    @mailchimp ||= Mailchimp::API.new(Spree::Config.get(:mailchimp_api_key), true)
  end

  # Gets the Mailchimp list ID that is stored in Spree::Config
  #
  # Returns a Mailchimp list ID String
  def mailchimp_list_id
    @mailchimp_list_id ||= Spree::Config.get(:mailchimp_list_id)
  end

  # Generates the subsubcription options for the application
  #
  # The option values are returned as an Array in the following order:
  #
  # double_optin      - Flag to control whether a double opt-in confirmation
  #                     message is sent, defaults to true. Abusing this may
  #                     cause your account to be suspended. (default: false)
  # update_existing   - Flag to control whether existing subscribers should be
  #                     updated instead of throwing an error. (default: true)
  #                     ( MailChimp's default is false )
  # replace_interests - Flag to determine whether we replace the interest
  #                     groups with the groups provided or we add the provided
  #                     groups to the member's interest groups. (default: true)
  # send_welcome      - If the double_optin is false and this is true, a welcome
  #                     email is sent out. If double_optin is true, this has no
  #                     effect. (default: false)
  #
  # Returns an Array of subscription options
  #
  # TODO: Add configuration options for 'update_existing' and 'replace_interests'
  # TODO: Remove configuration options for :mailchimp_send_notify
  def mailchimp_subscription_opts
    [Spree::Config.get(:mailchimp_double_opt_in), true, true, Spree::Config.get(:mailchimp_send_welcome)]
  end

  # Generates the merge variables for subscribing a user
  def mailchimp_merge_vars
    merge_vars = {}
    if mailchimp_merge_user_attribs = Spree::Config.get(:mailchimp_merge_vars)
      mailchimp_merge_user_attribs.split(',').each do |method|
        merge_vars[method.upcase] = self.send(method.downcase) if @user.respond_to? method.downcase
      end
    end
    merge_vars
  end

end
