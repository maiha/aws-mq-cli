# This provides sample codes for RabbitMQ Tutorials.
# https://www.rabbitmq.com/getstarted.html

Cmds.command "tutorials" do
  include Core
  include Core::Scenario

  # 1. https://www.rabbitmq.com/tutorials/tutorial-one-ruby.html
  task "hello_world" do
    case scenario_type
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
    case scenario_type
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
end
