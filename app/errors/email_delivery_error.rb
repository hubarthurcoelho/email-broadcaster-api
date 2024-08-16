class EmailDeliveryError < StandardError
  def initialize(msg = "Failed to deliver email")
    super
  end
end
