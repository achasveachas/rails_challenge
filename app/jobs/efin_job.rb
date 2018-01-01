class EfinJob < ApplicationJob
  queue_as :default

  def perform(data)
    if data['household'].to_i > 0 && data['income'].to_i > 0
      ActionCable.server.broadcast('EfinChannel', body: "Retrieving...")
      response = post(data)
      ActionCable.server.broadcast('EfinChannel', body: response)
    else
      ActionCable.server.broadcast('EfinChannel', body: "Sorry, an error has occured")
    end      
  end

  private

  def post(data)
    payload = {
      household: data['household'],
      income: data['income']
    }

    
    response = Faraday.post do |req|
      req.url 'http://efin.oddball.io'
      req.headers['Content-Type'] = 'application/json'
      req.body = data.to_json
    end
    parseXML(response.body)
  end

  def parseXML(xml)
    parsed = Nokogiri::XML(xml)
    efin = parsed.xpath('//root/efin')[0].content
  end

end
