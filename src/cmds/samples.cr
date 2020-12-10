# This provides sample codes for well known use cases.

Cmds.command "samples" do
  include Core
  include Core::Scenario

  class ConsumeFinished < Exception
  end
  
  task "ack_nack" do
    queue_name = "samples_ack_nack"
    case scenario_type
    when .run?
      channel.queue_delete(queue_name)

      queue    = channel.queue(queue_name)
      exchange = channel.default_exchange

      # Publish messages containing a number or a string.
      exchange.publish("100", routing_key: queue_name)
      exchange.publish("foo", routing_key: queue_name)
      exchange.publish("200", routing_key: queue_name)
      puts " [x] Published messages containing a number or a string."
      sleep 1

      # Consume with ack for numbers, and nack for others.
      puts " [*] Consuming with ack for numbers. (To exit press CTRL+C)"

      begin
        # consume at most 5 times
        rest = 5
        consume_at_most_5 = ->(message : AMQP::Client::DeliverMessage) {
          rest -= 1

          text = message.text
          case text
          when /^\d+$/
            puts " [x] Received [#{text}] (ack)"
            message.ack
          else
            puts " [x] Received [#{text}] (nack:requeue)"
            message.nack(requeue: true)
          end

          unless rest > 0
            sleep 1             # This sleep prevents from fast and massive loopback with nack and consume.
            raise ConsumeFinished.new("done")
          end
        }

        # This will consume 3 messsages, and requeue 1 messsage.
        queue.subscribe(block: false, no_ack: false, &consume_at_most_5)

        # This will consume requeue-ed message, and requeue it again.
        queue.subscribe(block: false, no_ack: false, &consume_at_most_5)

      rescue err : ConsumeFinished
        puts " [x] Consume finished. [#{err}]"
      end
      
    when .clean?
      channel.queue_delete(queue_name)
    end
  end
end
