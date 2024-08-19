class EmailValidatorService
  def validate_multiple(emails)
    errors = []

    emails.each do |email|
      err = validate(email)
      unless err.nil?
        errors << err
      end
    end

    errors
  end

  def validate(email)
    # in this class we could use an API to check the validity of an email address in the future
    unless email.is_a?(String) && email =~ URI::MailTo::EMAIL_REGEXP
      return "#{email} is not a valid email address"
    end

    nil
  end
end
