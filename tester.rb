require 'faraday'

class CustomErrors < Faraday::Middleware
  def call(env)
    begin
      @app.call(env)
    rescue Faraday::Error::ConnectionFailed => e
       url = env[:url].to_s.gsub(env[:url].path, '')
      $stderr.puts "The server at #{url} is either unavailable or is not currently accepting requests. Please try again in a few minutes."
    end
  end
end

class TestingFaradayExceptionHandling

  def conn
    @conn ||= Faraday.new('http://localhost:3001/') do |c|
      c.use CustomErrors
      c.use Faraday::Adapter::NetHttp
    end
  end
end

response = TestingFaradayExceptionHandling.new.conn.get '/cant-find-me'
