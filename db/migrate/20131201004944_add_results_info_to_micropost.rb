class AddResultsInfoToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :successCount, :integer
    add_column :microposts, :problemCount, :integer
    add_column :microposts, :successIds,  :string
    add_column :microposts, :problemIds, :string
  end
end
