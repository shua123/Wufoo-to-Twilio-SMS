class WufooJob < Struct.new(:micropost)
  def enqueue(job)
    micropost.update_attributes(:status => "In queue")
  end

  def perform
    micropost.update_attributes(:status => "Running")

    wufoo = WuParty.new(ENV['WUFOO_ACCOUNT'], ENV['WUFOO_KEY'])

    wuform = wufoo.form(ENV['WUFOO_FORMID'])
    wuformFilters = [[ENV['WUFIELD_SMSPERMS'], 'Contains', "YES"],\
                         [ENV['WUFIELD_PHNUM'], 'Is_not_NULL'],\
                        [ENV['WUFIELD_IPC'], 'Is_equal_to', micropost.ipc]]

    if micropost.langpref == "Spanish"
      wuformFilters.push([ENV['WUFIELD_SPANISH'], 'Contains', "Yes"])
    elsif micropost.langpref == "None"
      wuformFilters.push([ENV['WUFIELD_SPANISH'], 'Does_not_contain', "Yes"])
    end

    limit = 100
    pagenum = 0
    subtotal = 0
    entries = []
    countAll = wuform.count(:sort => 'EntryId ASC', :limit => limit, :pageStart => pagenum, :filters => wuformFilters)
    countAll = countAll.to_i
    while subtotal < countAll do
      entriesTemp = []
      entriesTemp = wuform.entries(:sort => 'EntryId ASC', :limit => limit, :pageStart => pagenum, :filters => wuformFilters)
      entries = entries | entriesTemp
      subtotal = entries.count
      pagenum = pagenum + limit
    end

    entriesUniq = entries.uniq { |entry| entry[ENV['WUFIELD_PHNUM']] }

    entriesCount = entriesUniq.count

    # Instantiate a Twilio client
    client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])

    successlist = []
    faillist = []
    entriesUniq.each do |entry|

      if entry[ENV['WUFIELD_SMSPERMS']] == "YES, we have permission to follow up by text." \
                              and entry[ENV['WUFIELD_PHNUM']] != ''\
                              and entry[ENV['WUFIELD_IPC']] == micropost.ipc


        thisNum = "+1" + entry[ENV['WUFIELD_PHNUM']]
        #puts thisNum     
        begin
          # Create and send an SMS message
          client.account.sms.messages.create(
          from: ENV['TWILIO_FROM'],
          to: thisNum,
          body: micropost.content
          )

          successlist.push(entry['EntryId'])
        rescue Twilio::REST::RequestError => e
          faillist.push(entry['EntryId'])
          puts e.message
        end
      end
    end
    # idString = successlist.join(", ")
    micropost.update_attributes(:successIds => successlist)
    # idString = faillist.join(", ")
    micropost.update_attributes(:problemIds => faillist)
    micropost.update_attributes(:successCount => successlist.count)
    micropost.update_attributes(:problemCount => faillist.count)
  end

  def before(job)
  end

  def after(job)
  end

  def success(job)
    micropost.update_attributes(:status => "Successful")
  end

  def error(job, exception)
    micropost.update_attributes(:status => "Error")
    micropost.update_attributes(:error_msg => exception)
  end

  def failure(job)
    micropost.update_attributes(:status => "Failed")
    micropost.update_attributes(:error_msg => job.last_error)
  end
end