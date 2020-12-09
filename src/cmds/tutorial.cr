Cmds.command "tutorial" do
  include Core

  # 1. https://www.rabbitmq.com/tutorials/tutorial-one-ruby.html
  task "hello_world" do
    case operation
    when .run?
      text = arg2? || "Hello World!"
      queue = channel.queue("hello")
      channel.default_exchange.publish(text, routing_key: queue.name)
      puts " [x] Sent '#{text}'"
    when .clean?
      channel.queue_delete("hello")
    end
  end

  # 2. https://www.rabbitmq.com/tutorials/tutorial-two-ruby.html
  task "work_queues" do
    case operation
    when .run?
      puts "[*] Waiting for messages. To exit press CTRL+C"
      queue = channel.queue("hello")
      queue.subscribe(block: true, no_ack: false) do |message|
        text = message.text
        puts " [x] Received [#{text}]"
        puts " [ ] Working..."
        sleep text.count(".")
        puts " [x] Done"
        message.ack
      end
    when .clean?
      channel.queue_delete("hello")
    end
  end

  private var operation  : Operation
  private var connection : AMQP::Client::Connection
  private var channel    : AMQP::Client::Channel = connection.channel

  enum Operation
    RUN
    CLEAN
  end

  def before
    super
    return if !self.class.task_names.includes?(task_name?.to_s)
    self.operation = Operation.parse?(arg1?.to_s) || raise ArgumentError.new(<<-EOF)
      usage: #{program_name} tutorial #{task_name} <run|clean>

             #{program_name} tutorial #{task_name} run
             #{program_name} tutorial #{task_name} clean


      EOF
    self.connection = AMQP::Client.new(endpoint_with_auth).connect
  end

  def after
    connection?.try(&.close)
    super
  end
end
