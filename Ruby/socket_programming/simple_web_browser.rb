require 'socket'
require 'json'

class WebBrowser

  def initialize
  end

  def send_socket(request, path, socket)
    request = "#{request} #{path} HTTP/1.0\r\n\r\n"
    socket.print(request)
  end

  def get_request
    valid_answer = false
    until valid_answer do
      puts 'What type of request would you like to send?'
      answer = gets.chomp!.downcase
      if answer == 'get' || answer == 'post'
        valid_answer = true
      else
        puts 'Please enter a valid request type.'
      end
    end
    answer
  end

  def get_POST_data
    puts 'You are registering a viking for a raid. Please enter the viking\'s name.'
    name = gets.chomp
    puts 'Now enter the viking\'s email!'
    email = gets.chomp
    {viking: {name: name, email: email}}.to_json
  end

  def run(host, port, path)

    socket = TCPSocket.open(host, port)
    request = get_request.upcase
    if request = 'GET'
      send_socket(request, path, socket)
    elsif request = 'POST'
      send_socket(request, path, socket)
      socket.print()

    response = socket.read

    headers,body = response.split("\r\n\r\n", 2)

    while line = socket.gets
      puts line.chop
    end

    puts body
  end
end

browser = WebBrowser.new
browser.run('localhost', 2000, '/index.html')
