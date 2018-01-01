require 'securerandom'
class EfinChannel < ApplicationCable::Channel
  def subscribed
    stream_from "EfinChannel"
  end
  def receive(data)
    EfinJob.perform_later(data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
