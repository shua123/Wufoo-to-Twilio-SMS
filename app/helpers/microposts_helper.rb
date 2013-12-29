module MicropostsHelper
  
  def messagesSent
    begin
        client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']) 
        list = client.account.messages.list({:from => ENV['TWILIO_FROM'], :page_size => 400})
    rescue => error
        flash[:error] =  "There was a problem loading sent messages from Twilio. Error message: #{error.message}"
        list = [] 
    end
  end

  def messagesReceived
    begin
        client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']) 
        listreceived = client.account.messages.list({:to => ENV['TWILIO_FROM'], :page_size => 400})
    rescue
        flash[:error] =  "There was a problem loading received messages from Twilio. Error message: #{error.message}"   
        list = []
    end
  end
  
end
