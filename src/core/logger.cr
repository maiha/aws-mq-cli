module Core
  protected def build_logger
    if v = logger_path?
      logger = Pretty::Logger.build_logger({"path" => (v == "-") ? "STDOUT" : v, "format" => "{{mark}},[{{time}}] {{message}}"})
    else
      logger = Pretty::Logger.build_logger({"format" => "{{message}}"})
    end
    logger.level = "DEBUG" if debug

    if verbose
      Log.setup do |c|
        case v = logger_path?
        when "-"
          backend = Log::IOBackend.new
        when String
          backend = Log::IOBackend.new(io: File.open(v, "w+"))
        else
          backend = Log::IOBackend.new
        end
        if debug
          c.bind "*", :debug, backend
        else
          c.bind "*", :info, backend
        end
      end
    end

    return logger
  end
end
