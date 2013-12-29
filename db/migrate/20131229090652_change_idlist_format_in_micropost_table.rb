class ChangeIdlistFormatInMicropostTable < ActiveRecord::Migration
  def change
  	change_column :microposts, :successIds, :text
  	change_column :microposts, :problemIds, :text
  end
end
