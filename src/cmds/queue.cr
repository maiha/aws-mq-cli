Cmds.command "queue" do
  include Core

  task "create", "<queue_name>" do
    queue_name = arg1("arg1: Missing queue name")

    connect do |ch|
      logger.debug "creating queue: #{queue_name}"
      ch.queue(name: queue_name)
    end
    logger.info "created queue: #{queue_name} [#{runtime}]"
  end

  task "delete", "<queue_name>" do
    queue_name = arg1("arg1: Missing queue name")

    connect do |ch|
      logger.debug "deleting queue: #{queue_name}"
      ch.queue_delete(name: queue_name)
    end
    logger.info "deleted queue: #{queue_name} [#{runtime}]"
  end

  task "purge", "<queue_name>" do
    queue_name = arg1("arg1: Missing queue name")

    connect do |ch|
      logger.debug "purging queue: #{queue_name}"
      ch.queue_purge(name: queue_name)
    end
    logger.info "purged queue: #{queue_name} [#{runtime}]"
  end
end
