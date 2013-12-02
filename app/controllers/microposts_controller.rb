class MicropostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      myresult = @micropost.send_text
      flash[:success] = "Scheduled job with IPC: #{@micropost.ipc}...\
                        Language: #{@micropost.langpref}...\
                        Message: #{@micropost.content}...\
                        Created At: #{myresult[:created_at].strftime("%m/%d/%Y %r")}...\
                        Run At: #{myresult[:run_at].strftime("%m/%d/%Y %r")}...\
                        Updated At: #{myresult[:updated_at].strftime("%m/%d/%Y %r")}"

    #   "priority",   default: 0, null: false
    # t.integer  "attempts",   default: 0, null: false
    # t.text     "handler",                null: false
    # t.text     "last_error"
    # t.datetime "run_at"
    # t.datetime "locked_at"
    # t.datetime "failed_at"
    # t.string   "locked_by"
    # t.string   "queue"
    # t.datetime "created_at"
    # t.datetime "updated_at"

      # if successlog.count > 0
      #   successlist = successlog * ";     "
      #   flash[:success] = "Sent #{successlog.count} Text Messages to:   #{successlist}"
      # end
      
      # if faillog.count > 0
      #   faillist = faillog * ";     "
      #   flash[:notice] = "Problem sending #{faillog.count} Text Messages to:   #{faillist}"
      # end

      # if successlog.count == 0 and faillog.count == 0
      #   flash[:notice] = "No entries matched the criteria. #{entriesCount}"
      # end
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
      params.require(:micropost).permit(:content, :ipc, :langpref)
    end

    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_url if @micropost.nil?
    end
end