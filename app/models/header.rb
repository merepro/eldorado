class Header < ActiveRecord::Base
  include PaperclipSupport

  attr_accessible :description

  belongs_to :user

  storage = case
  when Settings.s3_access_id && Settings.s3_secret_key && Settings.s3_bucket_name
    { :storage => :s3, :path => "headers/:filename", :bucket => Settings.s3_bucket_name,
      :s3_host_alias => Settings.s3_host_alias, :url => Settings.s3_host_alias ? ':s3_alias_url' : ':s3_path_url',
      :s3_credentials => { :access_key_id => Settings.s3_access_id, :secret_access_key => Settings.s3_secret_key },
      :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate } }
  else
    { :storage => :filesystem, :url => "/headers/:filename" }
  end

  has_attached_file :attachment, storage

  validates_attachment_presence :attachment
  validates_attachment_size :attachment, :less_than => 500.kilobytes
  validates_attachment_content_type :attachment, :content_type => /image/

  def self.random
    ids = connection.select_all("SELECT id FROM headers where votes >= 0")
    find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end

  def vote_up
    self.votes = self.votes + 1
    self.save(false)
  end

  def vote_down
    self.votes = self.votes - 1
    self.save(false)
  end
end
