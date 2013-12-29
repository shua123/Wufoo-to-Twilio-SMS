module MicropostsHelper
  
  def messagesSent
    begin
        client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']) 
        list = client.account.messages.list({:from => ENV['TWILIO_FROM'], :page_size => 200})
        listtemp = list
    rescue
        list = [{:sid => "Error loading messages."}]
    end
  end

  def messagesReceived
    begin
        client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']) 
        listreceived = client.account.messages.list({:to => ENV['TWILIO_FROM'], :page_size => 200})
    rescue
        list = [{:sid => "Error loading messages."}]
    end
  end
  
end
