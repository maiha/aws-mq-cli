# Stress test features
# * [qps] This provides a rough QPS by processing the number of QPS at once and then waiting until one second has elapsed.
Cmds.command "stress" do
  include Core

  private var queue_name : String = "stress"
  
  task "publish", "<qps> <payload_size(KB)>" do
    qps = arg1("arg1: missing the qps of publishing").to_i
    kb  = arg2?.try(&.to_i) || 4

    connect do |channel|
      queue = channel.queue(queue_name, durable: true)
      exchange = channel.default_exchange

      props = AMQ::Protocol::Properties.new(delivery_mode: 2) # persistent

      puts "[*] Publishing messages [#{qps}qps]. To exit press CTRL+C"
      total_count : Int32 = 0

      while true
        started_at = Pretty::Time.now
        # processing at once
        qps.times do |i|
          total_count += 1
          payload = ("message %010d" % [total_count]).ljust(kb * 1024)
          exchange.publish(payload, routing_key: queue.name, mandatory: true, props: props)
        end

        # reporting
        past_sec = (Pretty::Time.now - started_at).total_seconds
        this_qps = "%.1f" % (qps / past_sec) rescue "N/A"
        puts "[*] #{Pretty::Time.now}] Published #{qps} messages. (total: #{total_count}) [#{this_qps} qps]"

        # waiting until one second has elapsed
        rest_sec = 1 - past_sec
        sleep rest_sec if rest_sec > 0
      end
    end
  end

  task "consume", "<qps>" do
    qps = arg1("arg1: missing the qps of consuming").to_i
    
    connect do |channel|
      queue = channel.queue(queue_name)

      puts "[*] Consuming messages [#{qps}qps]. To exit press CTRL+C"
      total_count : Int32 = 0
      rest_count  : Int32 = qps

      started_at = Pretty::Time.now
      queue.subscribe(block: true, no_ack: false) do |message|
        # processing
        text = message.text
        message.ack
        rest_count -= 1
        total_count += 1

        # waiting until one second has elapsed if we reached to the number of qps
        if rest_count <= 0
          past_sec = (Pretty::Time.now - started_at).total_seconds
          this_qps = "%.1f" % (qps / past_sec) rescue "N/A"
          puts "[*] #{Pretty::Time.now}] Consumed #{qps} messages. (total: #{total_count}) [#{this_qps} qps]"

          rest_sec = 1 - past_sec
          sleep rest_sec if rest_sec > 0

          rest_count = qps
          started_at = Pretty::Time.now
        end
      end
    end
  end
end
