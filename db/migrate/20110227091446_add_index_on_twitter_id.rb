class AddIndexOnTwitterId < ActiveRecord::Migration
  def self.up
    add_index :tweets, :twitter_id, :unique => true
  end

  def self.down
    remove_index :tweets, :twitter_id
  end
end