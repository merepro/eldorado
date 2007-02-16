require 'digest/sha1'

class User < ActiveRecord::Base
  
  has_many :posts, :dependent => :destroy
  has_many :topics, :dependent => :destroy
  
  validates_presence_of     :login, :email, :password_hash
  validates_uniqueness_of   :login, :case_sensitive => false
  validates_length_of       :login, :maximum => 25
  
  attr_reader :password
  
  def password=(value)
    return if value.blank?
    write_attribute :password_hash, User.encrypt(value)
    @password = value
  end
  
  def self.authenticate(login, password)
    find_by_login_and_password_hash(login, encrypt(password))
  end
  
  def self.encrypt(password)
    Digest::SHA1.hexdigest(password + PASSWORD_SALT)
  end
  
  def self.users_online
    User.find(:all, :conditions => ["online_at > ?", Time.now.utc-5.minutes])
  end
    
end
