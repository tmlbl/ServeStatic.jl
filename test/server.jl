using HttpServer
using Meddle

include("../ServeStatic.jl")

stack = middleware(URLDecoder, ServeStatic("test/fixtures"))
http = HttpHandler((req, res) ->
	Meddle.handle(stack, MeddleRequest(req, Dict(), Dict()), res))

http.events["error"] = (client, err) -> println(err)
http.events["listen"] = (port) -> println("Listening on $port...")

server = Server(http)
run(server, 8084)
