class EfinJob < ApplicationJob
  queue_as :default

  def perform(data)
    ActionCable.server.broadcast('EfinChannel', body: "Hello World")
    response = post(data)
    ActionCable.server.broadcast('EfinChannel', sent_by: "Yechiel", body: response)
  end

  private

  def post(data)
    response = api.post('http://efin.oddball.io/', data.to_json)
    JSON.parse(response.body)
  end

  def api
    Faraday.new do |faraday|
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.headers['Content-Type'] = 'application/xml'
    end
  end
end
