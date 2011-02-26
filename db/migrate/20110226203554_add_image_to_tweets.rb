class AddImageToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :image, :string
  end

  def self.down
    remove_column :tweets, :image
  end
end
