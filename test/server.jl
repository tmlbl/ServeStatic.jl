using HttpServer
using Meddle

include("../Static.jl")

stack = middleware(URLDecoder, ServeStatic("test/fixtures"))
http = HttpHandler((req, res) ->
	Meddle.handle(stack, MeddleRequest(req, Dict(), Dict()), res))

for event in split("connect read write close error")
    http.events[event] = (event -> (client, args...) -> println(client.id,": $event"))(event)
end
http.events["error"] = (client, err) -> println(err)
http.events["listen"] = (port) -> println("Listening on $port...")

server = Server(http)
run(server, 8084)
