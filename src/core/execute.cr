module Core
  var runtime : Time::Span = 0.seconds
  
  private def connect
    started_at = Pretty::Time.now
    AMQP::Client.start(endpoint_with_auth) do |c|
      yield c.channel
    end
  ensure
    stopped_at = Pretty::Time.now
    if started_at
      self.runtime = stopped_at - started_at
    else
      self.runtime = 0.seconds
    end
  end
end
