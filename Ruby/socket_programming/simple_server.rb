require 'socket'

class Server
  def initialize
    @code_200 = "HTTP/1.0 200 OK\r\n"
    @code_404 = "HTTP/1.0 404 Not Found\r\n"
  end

  def parse_request(client)
    request_message = client.read_nonblock(256)
    request_message.split("\r\n\r\n", 2)
  end

  def serve_request(request)
    verb = request[/[[:upper:]]{3,4}/]
    path = request.match(/\/(?<path>[[:alnum:]]*.[[:alnum:]]*)/)['path']
    case verb
    when 'GET' then GET_serve(path)
    end
  end

  def GET_serve(path)
    if File.exist?(path)
      buffer = ''
      File.foreach(path) { |line| buffer += line }
      response = @code_200 + 
                'Date: ' + Time.now.utc.strftime("%a, %e %b %Y %H:%M:%S %Z") + "\r\n" +
                'Content-Length: ' + buffer.bytesize.to_s + "\r\n\r\n" +
                buffer
    else 
      response = @code_404 + "The page you were looking for could not be found."
    end
  end

  def run
    server = TCPServer.open(2000)

    loop {
      client = server.accept
      request,body = parse_request(client)

      response = serve_request(request)

      client.puts response
      client.puts(Time.now.ctime)
      client.puts 'Closing the connection. Bye!'
      client.close
    }
  end
end

server = Server.new
server.run