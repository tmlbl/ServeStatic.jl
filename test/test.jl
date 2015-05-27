using Requests
using Base.Test

println("It should respond with index.html")
response = get("http://0.0.0.0:8084")

@test response.status == 200
@test response.data == "<body>hello</body>"
