## A static file http server, based on express connect

using URIParser: parse_url
using Meddle
using HttpServer

export ServeStatic

path_in_dir(p::String, d::String) = length(p) > length(d) && p[1:length(d)] == d

function strip_trailing_slash(p::String)
  if p[length(p)] == '/' && p != "/"
    return p[1:length(p)-1]
  end
  p
end

function ServeStatic(root::String)
  Midware() do req::MeddleRequest, res::Response
    m = match(r"^/+(.*)$", req.state[:resource])
    if m != nothing
      path = normpath(root, m.captures[1])
#     # Protect against dir-escaping
      if !path_in_dir(path, root)
        return respond(req, Response(400)) # Bad Request
      end
      path = strip_trailing_slash(path)
      # Serve the requested file, if it exists
      if isfile(path)
        res.data = readall(path)
        return respond(req, res)
      end
      # Serve index.html if a request is made to the root
      if (path == normpath(root))
        res.data = readall(path * "/index.html")
        return respond(req, res)
      end
      req, res
    end
  end
end
