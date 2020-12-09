module Core
  def endpoint : URI
    URI.parse(arg_uri)
  end

  def endpoint_with_auth : URI
    uri = endpoint
    if arg_user?
      ary = arg_user.split(":", 2)
      uri.user     = ary[0]?
      uri.password = ary[1]?
    end
    return uri
  end
end
