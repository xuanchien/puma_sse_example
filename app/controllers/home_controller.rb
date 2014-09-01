require 'simple_app/sse'

class HomeController < ApplicationController
  include ActionController::Live
  def index
  end

  def check
    # SSE expects the `text/event-stream` content type
    response.headers['Content-Type'] = 'text/event-stream'

    sse = SimpleApp::SSE.new(response.stream)
    begin
      20.times do
        p "checking"
        messages = Message.where("created_at > ?", 3.seconds.ago).to_a
        unless messages.empty?
          p 'Write to client'
          p messages.as_json
          sse.write({messages: messages.as_json}, {event: 'refresh'})
        end
        sleep 3
      end
    rescue IOError
      # When the client disconnects, we'll get an IOError on write
    ensure
      sse.close
    end
  end
end
