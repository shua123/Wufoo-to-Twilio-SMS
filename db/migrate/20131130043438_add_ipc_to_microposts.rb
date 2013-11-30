class AddIpcToMicroposts < ActiveRecord::Migration
  def change
  	add_column :microposts, :ipc, :string
  end
end
