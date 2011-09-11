class Avatar < ActiveRecord::Base
  include PaperclipSupport

  belongs_to :user
  belongs_to :current_avatar_user, :foreign_key => 'current_user_id', :class_name => 'User'

  storage = case
  when Settings.s3_access_id && Settings.s3_secret_key && Settings.s3_bucket_name
    { :storage => :s3, :path => "avatars/:style_:filename", :bucket => Settings.s3_bucket_name,
      :s3_host_alias => Settings.s3_host_alias, :url => Settings.s3_host_alias ? ':s3_alias_url' : ':s3_path_url',
      :s3_credentials => { :access_key_id => Settings.s3_access_id, :secret_access_key => Settings.s3_secret_key },
      :s3_headers => { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate } }
  else
    { :storage => :filesystem, :url => "/avatars/:style_:filename" }
  end

  has_attached_file :attachment, { :styles => { :small => "32x32#", :medium =>"64x64#", :large => "184x184#" },
                                   :default_style => :medium }.merge(storage)

  validates_attachment_presence :attachment
  validates_attachment_size :attachment, :less_than => 500.kilobytes
  validates_attachment_content_type :attachment, :content_type => /image/

  before_create :randomize_file_name
  after_destroy :nullify_current_avatar_user

  private
  def randomize_file_name
    extension = File.extname(attachment_file_name).downcase
    self.attachment.instance_write(:file_name, "#{SecureRandom.hex(16)}#{extension}")
  end

  def nullify_current_avatar_user
    self.current_avatar_user.update_attribute(:avatar, nil) rescue nil
  end
end
