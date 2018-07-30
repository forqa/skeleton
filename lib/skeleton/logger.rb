class Log
  def self.info(message)
    puts "[INFO] #{Time.now}: #{message}".colorize(:light_cyan)
  end

  def self.warn(message)
    puts "[WARN] #{Time.now}: #{message}".colorize(:light_yellow)
  end

  def self.error(message)
    puts "[ERROR] #{Time.now}: #{message}".colorize(:light_red)
    Process.exit(1)
  end
end