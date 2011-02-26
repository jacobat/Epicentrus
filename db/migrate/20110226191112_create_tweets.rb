class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.text :data
      t.string :hashtag
      t.string :twitter_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
