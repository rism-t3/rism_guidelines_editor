class Logging
  def self.debug(message=nil)
    @log ||= Logger.new("#{Rails.root}/log/logging.log")
    @log.debug(message) unless message.nil?
  end
end
