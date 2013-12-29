class AddStatusToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :status, :string
    add_column :microposts, :error_msg, :string
  end
end
