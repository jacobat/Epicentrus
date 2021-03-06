# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110227101324) do

  create_table "tweets", :force => true do |t|
    t.text     "data"
    t.string   "hashtag"
    t.string   "twitter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "image_attachment_file_name"
    t.string   "image_attachment_content_type"
    t.integer  "image_attachment_file_size"
    t.datetime "image_attachment_updated_at"
  end

  add_index "tweets", ["twitter_id"], :name => "index_tweets_on_twitter_id", :unique => true

end
