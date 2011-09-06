class Theme < ActiveRecord::Base
  include PaperclipSupport

  belongs_to :user

  storage = case
  when Settings.s3_access_id && Settings.s3_secret_key && Settings.s3_bucket_name
    { :storage => :s3, :path => "themes/:filename", :bucket => Settings.s3_bucket_name,
      :s3_host_alias => Settings.s3_host_alias, :url => Settings.s3_host_alias ? ':s3_alias_url' : ':s3_path_url',
      :s3_credentials => { :access_key_id => Settings.s3_access_id, :secret_access_key => Settings.s3_secret_key },
      :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate } }
  else
    { :storage => :filesystem, :url => "/themes/:filename" }
  end

  has_attached_file :attachment, storage

  validates_attachment_presence :attachment
  validates_attachment_size :attachment, :less_than => 50.kilobytes
  validates_attachment_content_type :attachment, :content_type => /css/

  after_destroy :deselect

  def select
    Setting.first.update_attribute(:theme, self.attachment.url)
  end

  def deselect
    Setting.first.update_attribute(:theme, nil)
  end
end
