module Core::Scenario
  private var scenario_type : ScenarioType
  private var connection : AMQP::Client::Connection
  private var channel    : AMQP::Client::Channel = connection.channel

  enum ScenarioType
    RUN
    CLEAN
  end

  def before
    super
    return if !self.class.task_names.includes?(task_name?.to_s)
    self.scenario_type = ScenarioType.parse?(arg1?.to_s) || raise ArgumentError.new(<<-EOF)
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
