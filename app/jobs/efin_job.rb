class EfinJob < ApplicationJob
  queue_as :default

  def perform(data)
    ActionCable.server.broadcast('EfinChannel', body: "Hello World")
    response = post(data)
    puts "Response: #{response}"
    ActionCable.server.broadcast('EfinChannel', body: response)
  end

  private

  def post(data)
    payload = {
      household: data['household'].to_i,
      income: data['income'].to_i
    }

    
    response = Faraday.post do |req|
      req.url 'http://efin.oddball.io'
      req.headers['Content-Type'] = 'application/json'
      req.body = payload.to_json
    end
    parseXML(response.body)
  end

  def parseXML(xml)
    parsed = Nokogiri::XML(xml)
    efin = parsed.xpath('//root/efin')[0].content
  end

  def api
    Faraday.new do |faraday|
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.headers['Content-Type'] = 'application/xml'
    end
  end
end
