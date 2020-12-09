# stdlib
require "option_parser"
require "logger"

# shards
require "amqp-client"
require "ulid"
require "var"
require "pretty"
require "shard"
require "cmds"

# apps
require "./ext/**"
#require "./data/**"
require "./core/**"
require "./cmds/**"

class Main < Cmds::Cli::Default
  include Core

  def run(args)
    case args[0]?
    when "-h", "--help"
      help_and_exit!
    when "-V", "--version"
      STDOUT.puts Shard.git_description
    else
      super(args)
    end
  rescue err
    msg = err.to_s.chomp
    STDERR.puts msg.colorize(:red) if msg.presence
    exit 100
  end  
end

Main.run
