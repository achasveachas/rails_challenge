require 'securerandom'
class EfinChannel < ApplicationCable::Channel
  def subscribed
    stream_from "EfinChannel"
  end
  def receive(data)
    ActionCable.server.broadcast('EfinChannel', sent_by: "Yechiel", body: "Hello World")
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
