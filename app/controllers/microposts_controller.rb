class MicropostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      wufoo = WuParty.new(ENV['WUFOO_ACCOUNT'], ENV['WUFOO_KEY'])
      
      wuform = wufoo.form(ENV['WUFOO_FORMID'])
      entries = wuform.entries
      #numbers = entries[0]['Field4']

      # Instantiate a Twilio client
      client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])

      successlog = []
      faillog = []
      #flash[:success] = "Sent Text Messages to: "

      
      entries.each do |entry|

        if entry['Field110'] == "YES, we have permission to follow up by text." and entry['Field108'] != ''
          thisNum = "+1" + entry['Field108']
          #puts thisNum     
          begin
            # Create and send an SMS message
            client.account.sms.messages.create(
            from: ENV['TWILIO_FROM'],
            to: thisNum,
            body: "Testing text sending."
            )
            #puts "Sent message to #{thisNum}"
            successlog.push({:entryid => entry['EntryId'], :phone_number => entry['Field108']})
            #flash[:success] << "#{entry['EntryId']}   #{thisNum}"
            #flash[:success] = "Sent Text Messages to EntryId: #{entry['EntryId']} Phone Number: #{thisNum}"
            #flash[:notice] = "testing notice"
          rescue Twilio::REST::RequestError => e
            faillog.push({:entryid => entry['EntryId'], :phone_number => entry['Field108'], :error_message => e.message})
            puts e.message
          end
        end
      end
      
      if successlog.count > 0
        successlist = successlog * ";     "
        flash[:success] = "Sent Text Messages to:   #{successlist}"
      end
      
      if faillog.count > 0
        faillist = faillog * ";     "
        flash[:notice] = "Problem sending Text Messages to:   #{faillist}"
      end
      #flash[:notice] = "Sent Text Messages to EntryId: #{successlog[0][:entryid]} Phone Number: #{successlog[0][:number]}"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :ipc)
    end

    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_url if @micropost.nil?
    end
end