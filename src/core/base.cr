module Core
  var program_name : String = "aws-mq-cli"
  var dot_env : Hash(String, String) = load_dot_env

  # global options
  var arg_uri  : String = load_env?("AMAZON_MQ_URI") || "amqps://localhost:5671"
  var arg_user : String = load_env?("AMAZON_MQ_AUTH")

  var debug       : Bool   = false
  var dryrun      : Bool   = false
  var verbose     : Bool   = false
  var logger_path : String

  # cli variables
  var option_parser : OptionParser = build_option_parser
  
  def before
    option_parser.parse(args)
    @logger = build_logger
  end

  protected def build_option_parser
    option_parser = OptionParser.new
    setup_option_parser(option_parser)
    return option_parser
  end

  private def load_dot_env
    hash = Hash(String, String).new
    if File.readable?(".env")
      File.read(".env").scan(/^([A-Z][A-Z_-]*)=(.*?)$/m) do
        hash[$1] = $2
      end
    end
    return hash
  end
  
  protected def load_env?(key) : String?
    dot_env[key]? || ENV[key]?
  end
  
  def setup_option_parser(parser)
    if is_a?(Cmds::Cmd)
      parser.banner = "usage: #{program_name} [option] #{self.class.cmd_name} <task> [args]"
    else
      parser.banner = "usage: #{program_name} [option] <command> <task> [args]"
    end

    parser.on("-e", "--endpoint-uri <URI>", "endpoint uri") {|v| self.arg_uri = v}
    parser.on("-a", "--auth <USER:PASSWORD>", "user credentials") {|v| self.arg_user = v}
    parser.on("-l", "--log FILE", "Logging file name (default: STDOUT)") {|v| self.logger_path = v }
    parser.on("-d", "--debug", "Turn on debug message") {|v| self.debug = true }

    parser.on("-n", "--dryrun", "Dryrun mode") { self.dryrun = true }
    parser.on("-v", "--verbose", "Verbose mode") { self.verbose = true }
    parser.on("-h", "--help", "Show this help") { help_and_exit! }
  end

  protected def help_and_exit!
    puts option_parser
    examples = usages_for_cmd
    if examples.any?
      puts "\nexamples:"
      puts Pretty.lines(examples, indent: "    ", delimiter: " ")
    end
    if is_a?(Cmds::Cmd) && self.class.task_names.any?
      puts "\ntasks:\n  %s" % self.class.task_names.join(", ")
    end
    exit 0
  end
end
