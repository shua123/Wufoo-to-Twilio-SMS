class Micropost < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :ipc, presence: true
  validates :content, presence: true, length: { maximum: 160 }

  default_scope -> { order('microposts.created_at DESC') }

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

  def send_text
      wufoo = WuParty.new(ENV['WUFOO_ACCOUNT'], ENV['WUFOO_KEY'])
      
      wuform = wufoo.form(ENV['WUFOO_FORMID'])
      wuformFilters = [['Field110', 'Contains', "YES"],\
                           ['Field108', 'Is_not_NULL'],\
                          ['Field2', 'Is_equal_to', self.ipc]]

      if self.langpref == "Spanish"
        wuformFilters.push(['Field211', 'Contains', "Yes"])
      elsif self.langpref == "None"
        wuformFilters.push(['Field211', 'Does_not_contain', "Yes"])
      end

      limit = 5
      pagenum = 0
      subtotal = 0
      entries = []
      countAll = wuform.count(:sort => 'EntryId ASC', :limit => limit, :pageStart => pagenum, :filters => wuformFilters)
      countAll = countAll.to_i
      #while subtotal < countAll do
        entriesTemp = []
        entriesTemp = wuform.entries(:sort => 'EntryId ASC', :limit => limit, :pageStart => pagenum, :filters => wuformFilters)
        entries = entries | entriesTemp
        subtotal = entries.count
        pagenum = pagenum + limit
      #end

      entriesCount = entries.count
      # Instantiate a Twilio client
      client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])

      successlog = []
      successlist = []
      faillog = []
      faillist = []
      entries.each do |entry|

        if entry['Field110'] == "YES, we have permission to follow up by text." \
                                and entry['Field108'] != ''\
                                and entry['Field2'] == self.ipc


          thisNum = "+1" + entry['Field108']
          #puts thisNum     
          begin
            # Create and send an SMS message
            client.account.sms.messages.create(
            from: ENV['TWILIO_FROM'],
            to: thisNum,
            body: self.content
            )

            successlog.push({:entryid => entry['EntryId'], :phone_number => entry['Field108']})
            successlist.push(entry['EntryId'])
          rescue Twilio::REST::RequestError => e
            faillog.push({:entryid => entry['EntryId'], :phone_number => entry['Field108'], :error_message => e.message})
            faillist.push(entry['EntryId'])
            puts e.message
          end
        end
      end
      self.update_attributes(:successCount => successlog.count)
      self.update_attributes(:problemCount => faillog.count)
      self.update_attributes(:successIds => successlist*", ")
      self.update_attributes(:problemIds => faillist*", ")

  end
  handle_asynchronously :send_text

end
