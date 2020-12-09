class AMQP::Client
  struct BaseMessage
    def text
      String.new(body_io.to_slice)
    end
  end
end
