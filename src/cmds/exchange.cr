Cmds.command "exchange" do
  include Core

  task "create", "<name> <type>" do
    name = arg1("arg1: Missing exchange name")
    type = arg2("arg2: Missing exchange type")

    connect do |ch|
      logger.debug "creating exchange: #{name}"
      ch.exchange(name: name, type: type)
    end
    logger.info "created exchange: #{name} [#{runtime}]"
  end

  task "declare", "<name> <type>" do
    name = arg1("arg1: Missing exchange name")
    type = arg2("arg2: Missing exchange type")

    connect do |ch|
      logger.debug "creating exchange: #{name}"
      ch.exchange_declare(name: name, type: type)
    end
    logger.info "created exchange: #{name} [#{runtime}]"
  end

  task "delete", "<name>" do
    name = arg1("arg1: Missing exchange name")

    connect do |ch|
      logger.debug "deleting exchange: #{name}"
      ch.exchange_delete(name: name)
    end
    logger.info "deleted exchange: #{name} [#{runtime}]"
  end

  task "bind", "<exchange> <queue> <routing_key>" do
    exchange    = arg1("arg1: Missing exchange name")
    queue       = arg2("arg2: Missing queue name")
    routing_key = arg3("arg3: Missing routing key")

    connect do |ch|
      logger.debug "binding queue: #{queue} to #{exchange}"
      ch.queue_bind(queue: queue, exchange: exchange, routing_key: routing_key)
    end
    logger.info "bound queue: #{queue} to #{exchange} [#{runtime}]"
  end
  
  task "publish", "<exchange> <message>" do
    name = arg1("arg1: Missing exchange name")
    text = arg2("arg2: Missing message text")

    connect do |ch|
      logger.debug "publishing message: #{name} (#{text.size} bytes)"
      ch.basic_publish(text, exchange: name)
    end
    logger.info "published message: #{name} [#{runtime}]"
  end
end
