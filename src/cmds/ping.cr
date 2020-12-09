Cmds.command "ping" do
  include Core

  def run
    user = endpoint_with_auth.user
    logger.debug "connecting to #{endpoint} with auth(#{user}:xxxxxx)"
    connect do |ch|
      p ch
    end
  end
end
