class AddLangprefToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :langpref, :string, default: "None"
  end
end
