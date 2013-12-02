module MicropostsHelper
  
  def messagesSent
    client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']) 
    list = client.account.messages.list({:from => '+17732315471'})
    listtemp = list
    #while listtemp.next_page != []
    	listtemp = client.account.messages.list({:from => '+17732315471'}).next_page
    	list = list | listtemp
    	listtemp = client.account.messages.list({:from => '+17732315471'}).next_page
    	list = list | listtemp
    #end

   end

  def messagesReceived
    client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']) 
    listreceived = client.account.messages.list({:to => '+17732315471'})
    #listtemp = list
    #while listtemp.next_page != []
    	#listtemp = client.account.messages.list({:direction => 'Incoming'}).next_page
    	#list = list | listtemp
    	#listtemp = client.account.messages.list({:direction => 'Incoming'}).next_page
    	#list = list | listtemp
    #end

   end
end
