class AddImageAttachmentToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :image_attachment_file_name, :string
    add_column :tweets, :image_attachment_content_type, :string
    add_column :tweets, :image_attachment_file_size, :integer
    add_column :tweets, :image_attachment_updated_at, :datetime
  end

  def self.down
    remove_column :tweets, :image_attachment_updated_at
    remove_column :tweets, :image_attachment_file_size
    remove_column :tweets, :image_attachment_content_type
    remove_column :tweets, :image_attachment_file_name
  end
end