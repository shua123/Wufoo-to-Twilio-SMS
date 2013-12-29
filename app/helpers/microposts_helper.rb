module MicropostsHelper
  
  def messagesSent
    client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']) 
    list = client.account.messages.list({:from => ENV['TWILIO_FROM'], :page_size => 1000})
    listtemp = list
  end

  def messagesReceived
    client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']) 
    listreceived = client.account.messages.list({:to => ENV['TWILIO_FROM'], :page_size => 1000})
  end
  
end
